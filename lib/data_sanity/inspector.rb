module DataSanity
  class Inspector

    CONSIDERED_RECORDS = 1
    ALLOWED_VALIDATION = [:all, :random]
    attr_accessor :all, :random, :models, :records_per_model

    def initialize options = {}
      options[:validate] == :random ? @random = true : @all = true
      @records_per_model = options[:records_per_model] || CONSIDERED_RECORDS
      @models = load_models
    end

    def investigate
      @models.each do |model_string|
        model = model_string.constantize
        validate_all(model) if @all
        validate_random(model) if @random
      end
    end

    private

    def validate_all(model)
      model.all.each do |instance|
        populate_if_invalid_record(instance, model)
      end
    end

    def validate_random(model)
      no_of_records = model.count
      @records_per_model.times do
        instance = model.first(:limit => 1, :offset => rand(no_of_records))
        populate_if_invalid_record(instance, model)
      end
    end

    def populate_if_invalid_record(instance, model)
      DataInspector.create(:table_name => model.to_s,
                           :table_primary_key => model.primary_key,
                           :primary_key_value => instance.send(model.primary_key),
                           :validation_errors => instance.errors.full_messages.to_yaml) unless instance.valid?

    end

    def load_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |file_path| require file_path rescue nil }
      all_models = ActiveRecord::Base.descendants.select(&:descends_from_active_record?)
      all_models.delete(DataInspector)
      all_models.collect(&:name)
    end

  end
end
