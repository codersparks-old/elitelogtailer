require 'file/tail'
require 'logging'
require 'win32/sound'
include Win32

class EliteLogTailer
  def initialize(directory, end_of_file)
    @logger = Logging.logger[self]
    @directory = directory
    @logger.info("EliteLogTailer constructed looking at directory: #{@directory}")
    @end_of_file = end_of_file 
  end

  def tail(restClient)

    logFileName = self.find_latest_log()
    
    if logFileName == nil
      raise "Cannot find the latest log file"
    end
    
    @logger.info("Latest log: #{logFileName}")

    lastSystem = ""

    File.open(logFileName) do |log|
      log.extend(File::Tail)
      log.interval = 10
      log.backward(10)
      log.return_if_eof = @end_of_file
      log.tail { |line|
        # The following are for debug, do not uncommend unless you want lots of text on console
        #puts line
        @logger.debug("Parsing line: #{line}")
        parsed_system = parse_line(line)

        if parsed_system != nil
          if lastSystem != parsed_system
            @logger.debug("Found system: '#{parsed_system}' ... attempting to find in database")
            found_in_db = restClient.check_if_system_present(parsed_system)
            if found_in_db
              @logger.info("System #{parsed_system} found in db")
              lastSystem = parsed_system
            else
              @logger.info("System #{parsed_system} not found in db")
              Sound.play("sysnotfound.wav")
              lastSystem = parsed_system
            end
          else 
            if lastSystem == parsed_system
              @logger.info("Parsed system #{parsed_system} matches previous system #{lastSystem}")
            end
          end
        end
      }
    end
  end

  def find_latest_log()
    # Create a variable
    logFileGlob = File.join(@directory, "netLog.*")
    @logger.debug("logFileGlob set to '#{logFileGlob}'")

    latestLogFile = Dir.glob(logFileGlob).max_by { |f| File.mtime(f)}
    @logger.debug("Latest log file found to be '#{latestLogFile}'")

    return latestLogFile
  end

  def parse_line(line)

    system_regex = /.*System:[^\(]*\(([^\)]*).*/

    if(line.match(system_regex))
      parsed_system = line.match(system_regex).captures
      @logger.debug("Parsed system: '#{parsed_system[0]}'")
      return parsed_system[0]
    end

    return nil
  end
end

