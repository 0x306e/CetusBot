require_relative './syndicate'
require_relative './syndicate_jobs'

module CetusBot::API
  class OpenWorldSyndicate < Syndicate
    attr_reader :jobs
    def initialize(j)
      super(j)
      @jobs = []
      j['Jobs'].each{ |job|
        @jobs.push(SyndicateJobs.new(job))
      }
    end
  end
end