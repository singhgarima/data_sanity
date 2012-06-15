require 'spec_helper'

describe "DataSanity::Output" do

  describe "initialize" do
    it "should initialize the method of output of inspection" do
      output = DataSanity::Output.new :option => :table
      output.option.should == :table
    end

    it "should throw an exception if method not among specified options" do
      lambda { DataSanity::Output.new :option => :invalid }.should raise_error("This options to output the result of inspector is not valid")
    end
  end

  describe "store" do
    it "should store to data_inspector model when option is database" do
      output = DataSanity::Output.new :option => :table
      errors = ["error1", "error2"]
      instance = mock(:id => 2, :errors => mock(:full_messages => errors))
      model = mock(:to_s => "model", :primary_key => "id")
      output.create_from(model, instance)

      DataInspector.count.should == 1
      di = DataInspector.first
      di.table_name.should == "model"
      di.table_primary_key.should == "id"
      di.primary_key_value.should == "2"
      di.validation_errors.should == errors.to_yaml
    end

    it "should store to csv file in tmp folder of app" do
      output = DataSanity::Output.new :option => :csv
      errors = ["error1", "error2"]
      instance = mock(:id => 2, :errors => mock(:full_messages => errors))
      model = mock(:to_s => "model", :primary_key => "id")
      output.create_from(model, instance)
      output.close

      path = "#{Rails.root}/tmp/data_inspector.csv"
      contents = File.open(path) {|f| f.read }
      contents.should_not be_nil
      FasterCSV.read(path).should == [["table_name", "table_primary_key", "primary_key_value", "validation_errors"], 
        ["model", "id", "2", "error1 and error2"]]
    end
  end
end
