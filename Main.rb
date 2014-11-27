require 'optparse'
require 'logging'
require_relative  "EliteLogTailer"
require_relative "EDSCRestClient"

Logging.logger.root.level = :warn
Logging.logger.root.add_appenders(
  Logging.appenders.stdout
)
logger = Logging.logger["EliteLogTailerMain"]


options = {
  :dirname => nil,
  :logging => "WARN", 
  :test_db => false,
  :url => 'http://edstarcoordinator.com/api.asmx/GetSystems',
  :end_of_file => false
}

optparse = OptionParser.new do |opts|
  opts.on('-d', '--directory DIRECTORY', 'The directory containing the netLog files') do |d|
    options[:dirname] = d
  end
  opts.on('-l', '--logging LEVEL', "The level to log at (ERROR, WARN, INFO, DEBUG, OFF), Default: WARN - Note: Case sensitive") do |l|
    options[:logging] = l
  end
  opts.on('-t', '--test_db', "If supplied the script will use the test database") do |t|
    options[:test_db] = t
  end
  opts.on('-e', '--end_of_file', "If supplied the script will terminate at end of log file") do |e|
    options[:end_of_file] = e
  end
end


optparse.parse!

case options[:logging]
when "ERROR"
  Logging.logger.root.level = :error
when "WARN"
  Logging.logger.root.level = :warn
when "INFO"
  Logging.logger.root.level = :info
when "DEBUG"
  Logging.logger.root.level = :debug
when "OFF"
  Logging.logger.root.level = :off
else 
  Logging.logger.root.level = :warn 
end

if options[:dirname] == nil 
  raise "Log directory not supplied"
end

restClient = EDSCRestClient.new(options[:url], options[:test_db])
elt = EliteLogTailer.new(options[:dirname], options[:end_of_file])

elt.tail(restClient)