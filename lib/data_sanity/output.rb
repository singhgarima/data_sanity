require 'fastercsv'

class DataSanity::Output
  OPTIONS = [:table, :csv]

  attr_accessor :option, :csv_file
  def initialize options = {}
    raise Exception.new("This options to output the result of inspector is not valid") unless OPTIONS.include?(options[:option])
    self.option = options[:option]
    if self.option == :csv
      self.csv_file = FasterCSV.open("#{Rails.root}/tmp/data_inspector.csv", 'w') 
      self.csv_file.add_row ['table_name', 'table_primary_key', 'primary_key_value', 'validation_errors']
    end
  end

  def create_from model, instance
    send("store_to_#{self.option}", model, instance)
  end

  def close
    self.csv_file.close_write
  end

  private
  def store_to_table model, instance
    DataInspector.create(:table_name => model.to_s,
                         :table_primary_key => model.primary_key,
                         :primary_key_value => instance.send(model.primary_key),
                         :validation_errors => instance.errors.full_messages.to_yaml)
  end

  def store_to_csv model, instance
    self.csv_file.add_row [model.to_s, model.primary_key, instance.send(model.primary_key), instance.errors.full_messages.to_sentence]
  end
end
