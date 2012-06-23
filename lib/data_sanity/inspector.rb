module DataSanity
  class Inspector

    CONSIDERED_RECORDS = 1
    ALLOWED_VALIDATION = [:all, :random, :criteria]
    attr_accessor :all, :random, :criteria, :models, :records_per_model, :output

    def initialize options = {}
      @output = DataSanity::Output.new :option => ( options[:strategy] || :table ).to_sym
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
          @output.start_log model
          validate_all(model)
          @output.end_log
        end
      elsif @criteria
        @criteria.keys.each do |model|
          @output.start_log model
          validate_criteria(model.constantize, @criteria[model])
          @output.end_log
        end
      else
        @models.each do |model_string|
          @output.start_log model_string
          validate_random(model_string.constantize)
          @output.end_log
        end
      end
      @output.close
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
      @output.create_from model, instance unless instance.valid?
    rescue Exception => exp
      @output.create_from model, instance, exp
    end

    def load_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |file_path| require file_path rescue nil }
      all_models = ActiveRecord::Base.descendants.select(&:descends_from_active_record?).collect(&:name)
      all_models.delete("DataInspector")
      all_models
    end

  end
end
