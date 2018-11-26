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
  size = j['frames'].length
  index = Integer.rand(max=size-1)
  event.send(j['frames'][index])
end

bot.run