module DataSanity
  class Inspector

    ALLOWED_VALIDATION = [:all, :random]

    attr_accessor :all, :random, :models

    def initialize options = {}
      options[:validate] == :random ? @random = true : @all = true
      @models = load_models
    end
    
    private

    def load_models
      []
    end
  end
end
