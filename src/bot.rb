require 'discordrb'
require 'dotenv'

module CetusBot
    class Bot
        @bot

        def initialize()
            Dotenv.load('.env')
            @bot = Discordrb::Commands::CommandBot.new(
                token:     ENV['DISCORD_TOKEN'],
                client_id: ENV['DISCORD_CLIENT_ID'],
                prefix: '!',
            )
            self.setting
        end

        def setting()
            @bot.command :ping do |event|
                event.respond("pong (#{Time.now - event.timeStamp}sec. taken)")
            end
        end
    end
end
