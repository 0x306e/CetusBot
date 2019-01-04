require_relative '../world_state'

module CetusBot::API
  class Sorties
    class SortieMission
      def initialize(variants)
        @solNodes = File.open(File.expand_path('solNodes.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @missionTypes = File.open(File.expand_path('missionTypes.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @sortieData = File.open(File.expand_path('sortieData.json', CetusBot::WorldState::DATA_DIR)) do |f|
          JSON.load(f)
        end
        @missionType = @missionTypes[variants['missionType']]['value']
        @modifierType = @sortieData['modifierTypes'][variants['modifierType']]
        @node = @solNodes[variants['node']]['value']
        @tileset = variants['tileset']
      end
      attr_reader :missionType, :modifierType, :node, :tileset
    end
    private_constant :SortieMission

    def initialize
      @state = CetusBot::WorldState.instance
    end

    def activation
      return Time.at(@state.json['Sorties'][0]['Activation']['$date']['$numberLong'].to_i/1000)
    end

    def expiry
      return Time.at(@state.json['Sorties'][0]['Expiry']['$date']['$numberLong'].to_i/1000)
    end

    def factions
      return @state.json['Sorties'][0]['Boss']
    end

    def first
      return SortieMission.new(@state.json['Sorties'][0]['Variants'][0])
    end

    def second
      return SortieMission.new(@state.json['Sorties'][0]['Variants'][1])
    end

    def last
      return SortieMission.new(@state.json['Sorties'][0]['Variants'][2])
    end
  end
end

