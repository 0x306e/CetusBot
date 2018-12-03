module CetusBot::API
  class Sorties
    @state

    class SortieMission
      def initialize(variants)
        @missionType = variants['missionType']
        @modifierType = variants['modifierType']
        @node = variants['node']
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