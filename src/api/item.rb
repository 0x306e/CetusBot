require 'json'
require_relative './LanguageJsonTranslation'

module CetusBot::API
  class Item
    include CetusBot::API::LanguageJsonTranslation
    def initialize(lang=nil, amount=nil)
      @name = get(lang.downcase)
      @amount = amount
    end
  end
end
