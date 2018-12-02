require 'discordrb'
require 'dotenv'
require_relative './world_state'

module CetusBot
    class Bot
        @bot
        @state
        @GACHA_JSON
        def initialize
            Dotenv.load('~/.env')
            @bot = Discordrb::Commands::CommandBot.new(
                token:     ENV['DISCORD_TOKEN'],
                client_id: ENV['DISCORD_CLIENT_ID'],
                prefix: '!',
            )
            @state = CetusBot::WorldState.new
            @GACHA_JSON = open(File.expand_path('../src/data.json'), 'r') do |j|
                JSON.load(j)
            end
            self.setting
        end

        def run
            @bot.run
        end

        def setting # command setups
            @bot.command :ping do |event|
                m = event.send('pong')
                m.edit("pong (#{Time.now - event.timestamp}sec)")
            end

            @bot.command :ctime do |event|
                remain = @state.eidlon_time()[:expiry]
                remain = remain / 1000 - Time.now.to_i
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
                event.send(self.rand_frame)
            end

            @bot.command :advgacha do |event|
                event.send(self.rand_frame << ', ' << self.rand_dragon_key)
            end

            @bot.command :dice do |event, max|
                max ||= 6
                val = max.to_i
                event.send(rand(1..val))
            end
        end

        def rand_frame
            size = @GACHA_JSON['frames'].length()
            index = Random.new.rand(size)
            return @GACHA_JSON['frames'][index]
        end

        def rand_dragon_key
            size = @GACHA_JSON['dragon_keys'].length()
            index = Random.new.rand(size)
            return @GACHA_JSON['dragon_keys'][index]
        end
    end
end
