require_relative '../world_state'
require_relative './reward'

module CetusBot::API
  class Alerts
    class Alert
      def initialize(json)
        @solNodes = File.open(File.expand_path('solNodes.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @missionTypes = File.open(File.expand_path('missionTypes.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @factionData = File.open(File.expand_path('factionsData.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @activation = json['Activation']['$date']['$numberLong']
        @expiry = json['Expiry']['$date']['$numberLong']
        @missionType = @missionTypes[json['MissionInfo']['missionType']]['value']
        @faction = @factionData[json['MissionInfo']['faction']]['value']
        @node = @solNodes[json['MissionInfo']['location']]
        @reward = Reward.new(json['MissionInfo']['missionReward'])
      end
      attr_reader :activation, :expiry, :missionType, :faction, :node, :reward
    end

    def initialize
      @state = CetusBot::WorldState.instance
    end

    def now_list
      array = []
      @state.json['Alerts'].each {|j|
        array.push(Alert.new(j))
      }
      return array
    end
  end
end