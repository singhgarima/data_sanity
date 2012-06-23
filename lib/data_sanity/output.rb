require 'fastercsv'

module DataSanity
  class Output
    OPTIONS = [:table, :csv]

    attr_accessor :option, :csv_file
    def initialize options = {}
      raise Exception.new("This options to output the result of inspector is not valid") unless OPTIONS.include?(options[:option])
      self.option = options[:option]
      @count = 0
      if self.option == :csv
        self.csv_file = FasterCSV.open("#{Rails.root}/tmp/data_inspector.csv", 'w') 
        self.csv_file.add_row ['table_name', 'table_primary_key', 'primary_key_value', 'validation_errors']
      end
    end

    def create_from model, instance, exception = nil
      send("store_to_#{self.option}", model, instance, exception)
    end

    def close
      self.csv_file.close_write if self.csv_file
    end

    def start_log model
      puts "==> Inspecting :: " + model.to_s
    end

    def end_log
      puts "==> Inspection completed and found #{@count} validation(s) defaulters"
    end

    private
    def store_to_table model, instance, exception
      DataInspector.create(:table_name => model.to_s,
                           :table_primary_key => model.primary_key,
                           :primary_key_value => instance.send(model.primary_key),
                           :validation_errors => (exception || instance.errors.full_messages.to_yaml))
      @count += 1
    end

    def store_to_csv model, instance, exception
      self.csv_file.add_row [model.to_s, model.primary_key, instance.send(model.primary_key), ( exception || instance.errors.full_messages.to_sentence) ]
      @count += 1
    end
  end
end
