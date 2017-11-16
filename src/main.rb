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

bot.command :help do |event|
  event.send(<<"EOS")
Command usage
!ping : return 'pong'
!ctime : Display Cetus time status
EOS
end

bot.command :ctime do |event|
  unixTime = Time.now.to_i

  # get Cetus time
  uri = URI.parse('http://content.warframe.com/dynamic/worldState.php')
  json = Net::HTTP.get(uri)
  raw = JSON.parse(json)
  Activation = raw['SyndicateMissions'][9]['Activation']['$date']['$numberLong'].to_i
  Expiry = raw['SyndicateMissions'][9]['Expiry']['$date']['$numberLong'].to_i

  State = 'Night'
  remain = (Expiry / 1000) - unixTime

  if remain > 3000
    State = 'Day'
    remain = remain - 3000
  end
  hour = remain / 3600
  minutes = (remain % 3600) / 60
  seconds = remain % 60

  event.send("Now in #{State}, left to #{hour}h #{minutes}m #{seconds}s.")
end

bot.run