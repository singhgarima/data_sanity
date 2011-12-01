module DataSanity
  class Inspector

    ALLOWED_VALIDATION = [:all, :random]

    attr_accessor :all, :random, :models

    def initialize options = {}
      options[:validate] == :random ? @random = true : @all = true
      @models = load_models
    end

    def investigate
      @models.each do |model_string|
        model = model_string.constantize
        model.all.each do |instance|
          unless instance.valid?
            DataInspector.create(:table_name => model_string,
                                 :table_primary_key => model.primary_key,
                                 :primary_key_value => instance.send(model.primary_key),
                                 :validation_errors => instance.errors.full_messages.to_yaml)
          end
        end
      end
    end

    private

    def load_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |file_path| require file_path rescue nil }
      ActiveRecord::Base.descendants.select(&:descends_from_active_record?).collect(&:name)
    end
  end
end
