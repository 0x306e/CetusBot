require_relative '../world_state'
require_relative './syndicate'
require_relative './open_world_syndicate'

module CetusBot::API
  class SyndicateMissions
    attr_reader :syndicates
    def initialize
      @state = CetusBot::WorldState.instance
      json = @state.json
      @syndicates = {}
      json['SyndicateMissions'].each{ |j|
        if j.has_key?('Jobs')
          @syndicates[j['Tag']] = OpenWorldSyndicate.new(j)
        else
          @syndicates[j['Tag']] = Syndicate.new(j)
        end
      }
    end
  end
end