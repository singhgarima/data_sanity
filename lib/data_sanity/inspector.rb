module DataSanity
  class Inspector

    CONSIDERED_RECORDS = 1
    ALLOWED_VALIDATION = [:all, :random, :criteria]
    attr_accessor :all, :random, :criteria, :models, :records_per_model

    def initialize options = {}
      options[:validate] == "random" ? @random = true : @all = true
      @records_per_model = options[:records_per_model].to_i == 0 ? CONSIDERED_RECORDS : options[:records_per_model].to_i
      @models = load_models
      file_path = "#{Rails.root}/config/data_sanity_criteria.yml"
      @criteria = (File.exists?(file_path) ? (YAML.load File.open(file_path).read) : false) rescue false
    end

    def investigate
      if @all
        considered_models = @criteria ? @criteria.keys : @models
        considered_models.each do |model_string|
          model = model_string.constantize
          log_start(model)
          validate_all(model)
          log_end(model)
        end
      elsif @criteria
        @criteria.keys.each do |model|
          log_start(model)
          validate_criteria(model.constantize, @criteria[model])
          log_end(model)
        end
      else
        @models.each do |model_string|
          log_start(model_string)
          validate_random(model_string.constantize)
          log_end(model_string)
        end
      end
    end

    private

    def validate_all(model)
      model.find_each do |instance|
        populate_if_invalid_record(instance, model)
      end
    end

    def validate_random(model)
      no_of_records = model.count
      return if no_of_records == 0
      [@records_per_model, no_of_records].min.times do
        instance = model.offset(rand(no_of_records)).first
        populate_if_invalid_record(instance, model)
      end
    end

    def validate_criteria(model, criteria)
      validate_random(model) and return if criteria.blank?
      criteria.each do |attribute, values|
        values = (model.select("DISTINCT(#{attribute})").collect(&attribute.to_sym)) if values.blank?
        values.each do |value|
          results = model.where(attribute.to_sym => value)
          count = results.count
          next if count == 0
          [@records_per_model, count].min.times do
            instance = results.offset(rand(count)).first
            populate_if_invalid_record(instance, model)
          end
        end
      end
    end

    def populate_if_invalid_record(instance, model)
      DataInspector.create(:table_name => model.to_s,
                           :table_primary_key => model.primary_key,
                           :primary_key_value => instance.send(model.primary_key),
                           :validation_errors => instance.errors.full_messages.to_yaml) unless instance.valid?
    rescue Exception => exp
      DataInspector.create(:table_name => model.to_s,
                           :table_primary_key => model.primary_key,
                           :primary_key_value => instance.send(model.primary_key),
                           :validation_errors => exp.to_yaml)
    end

    def load_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |file_path| require file_path rescue nil }
      all_models = ActiveRecord::Base.descendants.select(&:descends_from_active_record?).collect(&:name)
      all_models.delete("DataInspector")
      all_models
    end

    def log_start model
      puts "==> Inspecting :: " + model.to_s
    end

    def log_end model
      validation_count = DataInspector.where(:table_name => model.to_s).count
      puts "==> Inspection completed and found #{validation_count} validation(s) defaulters"
    end

  end
end
