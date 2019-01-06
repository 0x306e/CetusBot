require 'singleton'
require 'net/http'
require 'json'
require_relative 'api/alerts'
require_relative 'api/sorties'
require_relative 'api/syndicate_missions'


module CetusBot
    class WorldState
        include Singleton
        URL = URI.parse('http://content.warframe.com/dynamic/worldState.php')
        DATA_DIR = File.expand_path('../../warframe-worldstate-data/data/', __FILE__)

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
          CetusBot::API::Alerts.new
        end

        def sorties
          CetusBot::API::Sorties.new
        end

        def syndicates
          CetusBot::API::SyndicateMissions.new
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
