module CetusBot::API
  module JsonDataGetter
    DATA_DIR = File.expand_path('../../../warframe-worldstate-data/data/', __FILE__)
    Arcanes = 'arcanes.json'
    ConclaveData = 'conclaveData.json'
    EventsData = 'eventsData.json'
    FactionsData = 'factionsData.json'
    FissureModifiers = 'fissureModifiers.json'
    Languages = 'languages.json'
    MissionTypes = 'missionTypes.json'
    OperationTypes = 'operationTypes.json'
    PersistentEnemyData = 'persistentEnemyData.json'
    SolNodes = 'solNodes.json'
    SortieData = 'sortieData.json'
    SyndicatesData = 'syndicatesData.json'
    SynthTargets = 'synthTargets.json'
    Tutorials = 'tutorials.json'
    UpgradeTypes = 'upgradeTypes.json'
    Warframes = 'warframes.json'
    Weapons = 'weapons.json'

    def getJsonData(file=nil, path=nil)
      json = open(File.expand_path(file, DATA_DIR)) do |f|
        JSON.load(f)
      end
      lower = json[path.downcase]
      upper = json[path]
      solved = lower ? lower : upper
      if solved.is_a?(Hash) && solved.has_key?('value')
        return solved['value']
      end
      return solved
    end

    module_function :getJsonData
  end
end