require 'discordrb'
require 'json'
require 'net/http'

bot = Discordrb::Commands::CommandBot.new(
    token: 'YOUR_TOKEN',
    client_id: 'YOUR_ID',
    prefix: '!',
)

bot.command :ping do |event|
  event.send('pong')
end

bot.command :etime do |event|
  uri = URI.parse('http://content.warframe.com/dynamic/worldState.php')
  json = Net::HTTP.get(uri)
  raw = JSON.parse(json)
  unixTime = raw['SyndicateMissions'][9]['Expiry']['$date']['$numberLong']
  event.send(unixTime)
end

bot.run