module CetusBot::API
  module LanguageJsonTranslation
    Language = open(File.expand_path('languages.json', CetusBot::WorldState::DATA_DIR)) do |f|
      JSON.load(f)
    end
    def get(path)
      return Language[path]['value']
    end

    module_function :get
  end
end