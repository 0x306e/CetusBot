require_relative './item'

module CetusBot::API
  class Reward
    def initialize(reward)
      @credit = reward['credits']
      @item = nil
      if reward.has_key?('items')
        @item = Item.new(lang=reward['items'][0], amount=1)
      end
      if reward.has_key?('countedItems')
        @item = Item.new(lang=reward['countedItems'][0]['ItemType'], amount=reward['countedItems'][0]['ItemCount'])
      end
    end
  end
end