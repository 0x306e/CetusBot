require 'discordrb'
require 'dotenv'
require_relative './world_state'

module CetusBot
    class Bot
        @bot
        @state

        def initialize()
            Dotenv.load('.env')
            @bot = Discordrb::Commands::CommandBot.new(
                token:     ENV['DISCORD_TOKEN'],
                client_id: ENV['DISCORD_CLIENT_ID'],
                prefix: '!',
            )
            @state = CetusBot::WorldState.new
            self.setting()
        end

        def run()
            @bot.run()
        end

        def setting() # command setups
            @bot.command :ping do |event|
                event.respond("pong (#{Time.now - event.timeStamp}sec)")
            end

            @bot.command :ctime do |event|
                remain = @state.eidlon_time() / 1000 - Time.now.to_i
                state = case remain
                        when 0..(50*60)
                            'Night'
                        else
                            'Day'
                        end

                if remain < 0
                    remain += 150 * 60
                end
                if remain > 3000
                    state = 'Day'
                    remain = remain - 3000
                end
                h = remain / 3600
                m = (remain % 3600) / 60
                s = remain % 60

                event.respond("Now in #{state}, left to #{h}h #{m}m #{s}s.")
            end

            @bot.command :gacha do |event|
                j = nil
                File.open('./FrameList.json', 'r') do |f|
                    j = JSON.load(f)
                end
                size = j['frames'].length()
                index = Random.new.rand(size)
                event.send(j['frames'][index])
            end

            @bot.command :dice do |event, max|
                max ||= 6
                val = max.to_i
                event.send(rand(1..val))
            end
        end
    end
end
