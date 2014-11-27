require 'logging'
require 'rest_client'

class EDSCRestClient
  
  def initialize(url, test)
    @logger = Logging.logger[self]
    @test = test;
    @url = url;
    @logger.info("EDSCRestClient constructed for url: #{@url}")
    @logger.debug("Using test database: #{@test}")
  end
  
  def check_if_system_present(system)
    
    # Construct the body data using Hash => json
    postData = { 
      :data => {
          :ver => 2,
          :test => @test,
          :outputmode => 1,
          :filter => {
              :cr => 0,
              :knownstatus => 1,
              :systemname => system,
              :date => "2000-01-01 00:00:00"
          }
      }
    }.to_json
    @logger.debug("Rest query json string: #{postData.to_s}")
    response = RestClient.post @url, postData.to_s, :content_type => :json
    
    if response.code != 200
      @logger.error("Non ok status returned from rest call, code : #{response.code}")
      raise "RESTful call did not return ok status"
    end
    
    response_json = JSON.parse(response.to_str)
    @logger.debug("Returned JSON: #{response_json}")
    @logger.info("Parsing returned JSON....")
    
    response_json["d"]["systems"].each do |json_system|
      @logger.debug("System=>Name: #{json_system['name']}")
      if json_system['name'].casecmp(system) == 0
        @logger.info("Match found for system #{system}")
        return true
      end
      
    end
    @logger.info("No match found for system #{system}")
    return false
  end
  
  
end