module CetusBot
    class WorldState
        @response
        @json
        @uptime
        URL = URI.parse('http://content.warframe.com/dynamic/worldState.php')
        def initialize
            self.update
        end

        def update
            now = Time.now
            if (now - @uptime).to_i > 60*5
                @response = Net::HTTP.get(URL)
                @json = JSON.parse(@response)
                @uptime = Time.now
            end
        end

        def events
        end

        def alerts
        end

        def sorties
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
            now = Time.now.to_i
            # get Cetus time
            syndicates = @json['SyndicateMissions']
            (0..20).each {|i|
                if syndicates[i]['Tag'] == 'CetusSyndicate'
                    activation = syndicates[i]['Activation']['$date']['$numberLong'].to_i
                    expiry = syndicates[i]['Expiry']['$date']['$numberLong'].to_i
                    break
                end
            }

            return activation, expiry
        end

        def solaris_time
        end
    end
end
