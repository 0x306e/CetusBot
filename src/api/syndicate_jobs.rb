
module CetusBot::API
  class SyndicateJobs
    include CetusBot::API::JsonDataGetter
    attr_reader :jobType, :reward, :xpAmounts
    def initialize(j)
      @jobType = getJsonData(file=Languages, path=j['jobType'])
      @reward = getJsonData(file=Languages, path=j['rewards'])
      @xpAmounts = j['xpAmounts'].sum
    end
  end
end