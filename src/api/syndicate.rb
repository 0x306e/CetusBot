require_relative './JsonDataGetter'

class Syndicate
  include CetusBot::API::JsonDataGetter
  attr_reader :activation, :expiry, :name, :node
  def initialize(j)
    @activation = Time.at(j['Activation']['$date']['$numberLong'].to_i/1000)
    @expiry = Time.at(j['Expiry']['$date']['$numberLong'].to_i/1000)
    @name = getJsonData(SyndicatesData, j['Tag'])['name']
    @node = []
    j['Nodes'].each{ |node|
      @node.push(getJsonData(SolNodes, node))
    }
  end
end
