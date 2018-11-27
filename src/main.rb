require 'discordrb'
require 'json'
require 'net/http'
require 'dotenv'

Dotenv.load('.env')
bot = Discordrb::Commands::CommandBot.new(
    token:     ENV['DISCORD_TOKEN'],
    client_id: ENV['DISCORD_CLIENT_ID'],
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
!gacha : frame gacha
!dice [max_number] : roll dice. default max_number is 6.
EOS
end

bot.command :ctime do |event|
  unixTime = Time.now.to_i

  # get Cetus time
  uri = URI.parse('http://content.warframe.com/dynamic/worldState.php')
  json = Net::HTTP.get(uri)
  raw = JSON.parse(json)
  syndicates = raw['SyndicateMissions']
  (0..20).each {|i|
    if syndicates[i]['Tag'] == 'CetusSyndicate'
      Activation = syndicates[i]['Activation']['$date']['$numberLong'].to_i
      Expiry = syndicates[i]['Expiry']['$date']['$numberLong'].to_i
      break
    end
  }

  # parse time format
  remain = (Expiry / 1000) - unixTime
  State = case remain
            when 0..(50 * 60)
              'Night'
            else
              'Day'
          end

  if remain < 0
    remain += 150 * 60
  end
  if remain > 3000
    State = 'Day'
    remain = remain - 3000
  end
  hour = remain / 3600
  minutes = (remain % 3600) / 60
  seconds = remain % 60

  event.send("Now in #{State}, left to #{hour}h #{minutes}m #{seconds}s.")
end

bot.command :gacha do |event|
  j = nil
  File.open('FrameList.json', 'r') do |f|
    j = JSON.load(f)
  end
  size = j['frames'].length()
  index = Random.new.rand(size)
  event.send(j['frames'][index])
end

bot.command :dice do |event, max|
  max ||= 6
  val = max.to_i
  event.send(rand(1..val))
end

bot.run

