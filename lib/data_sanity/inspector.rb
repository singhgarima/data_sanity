module DataSanity
  class Inspector

    ALLOWED_VALIDATION = [:all, :random]

    attr_accessor :all, :random, :models

    def initialize options = {}
      options[:validate] == :random ? @random = true : @all = true
      @models = load_models
    end

    def investigate
      
    end

    private

    def load_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |file_path| require file_path rescue nil }
      ActiveRecord::Base.descendants.select(&:descends_from_active_record?).collect(&:name)
    end
  end
end
