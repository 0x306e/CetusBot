require 'json'
require_relative './JsonDataGetter'

module CetusBot::API
  class Item
    include CetusBot::API::JsonDataGetter
    def initialize(lang=nil, amount=nil)
      @name = getJsonData(file=JsonDataGetter::Languages, path=lang.downcase)['value']
      @amount = amount
    end
  end
end
