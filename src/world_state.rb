require 'singleton'
require 'net/http'
require 'json'

module CetusBot
    class WorldState
        include Singleton
        @response
        @json
        @uptime
        URL = URI.parse('http://content.warframe.com/dynamic/worldState.php')

        def update
            now = Time.now
            if @uptime.nil? || now - @uptime > 60*5
                @response = Net::HTTP.get(URL)
                @json = JSON.parse(@response)
                @uptime = Time.now
            end
        end

        def json
            self.update
            return @json
        end

        def events
        end

        def alerts
        end

        def sorties
            sortie = self.json['Sorties'][0]
            activation = sortie['Activation']['$date']['$numberLong']
            expiry = sortie['Expiry']['$date']['$numberLong']
            boss = sortie['Boss']
            variants = [
                {
                    'missionType':  sortie['Variants'][0]['missionType'],
                    'modifierType': sortie['Variants'][0]['modifierType'],
                },
                {
                    'missionType':  sortie['Variants'][1]['missionType'],
                    'modifierType': sortie['Variants'][1]['modifierType'],
                },
                {
                    'missionType':  sortie['Variants'][2]['missionType'],
                    'modifierType': sortie['Variants'][2]['modifierType'],
                }
            ]
            return {'activation': activation, 'expiry': expiry, 'boss': boss, 'variants': variants}
        end

        def syndicates
        end

        def invasions
        end

        def void_trader
        end

        def void_fissures
        end

        def eidlon_time
            # get Cetus time
            activation = nil
            expiry = nil
            syndicates = self.json['SyndicateMissions']
            (0..20).each {|i|
                if syndicates[i]['Tag'] == 'CetusSyndicate'
                    activation = syndicates[i]['Activation']['$date']['$numberLong'].to_i
                    expiry = syndicates[i]['Expiry']['$date']['$numberLong'].to_i
                    break
                end
            }

            return {'activation': activation, 'expiry': expiry}
        end

        def solaris_time
        end
    end
end
