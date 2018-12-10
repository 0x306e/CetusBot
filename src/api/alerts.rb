require_relative '../world_state'

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
        @factionData = File.open(File.expand_path('factionData.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @activation = json['Activation']['$date']['$numberLong']
        @expiry = json['Expiry']['$date']['$numberLong']
        @missionType = @missionTypes[json['MissionInfo']['missionType']]
        @faction = @factionData[json['MissionInfo']['faction']]
        @node = @solNodes[json['MissionInfo']['location']]
        @reward = json['MissionInfo']['MissionReward']
      end
      attr_reader :activation, :expiry, :missionType, :faction, :node, :reward
    end

    def initialize
      @state = CetusBot::WorldState.instance
    end

    def now_list
      list = []
      @state.json['Alerts'].each {|j|
        list.append(Alert.new(j))
      }
      return list
    end
  end
end