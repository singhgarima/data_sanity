require 'spec_helper'


describe "DataSanity::Inspector" do

  describe "initialize" do
    it "should set all switch as default options and populate all models of the applications" do
      inspector = DataSanity::Inspector.new
      inspector.all.should be_true
      inspector.models.should == ["Person"]
    end
  end

  describe "investigate" do
    before :each do
      setup_data_inspector
    end

    it "should check for errors on the model and populate fields in DataInspector" do
      inspector = DataSanity::Inspector.new
      inspector.investigate
      DataInspector.count.should == 0
    end

    after :each do
      clean_data_inspector_migration
    end
  end

end
