require 'spec_helper'

describe "DataSanity::Inspector" do

  describe "initialize" do
    it "should set all switch as default options and populate all models of the applications" do
      inspector = DataSanity::Inspector.new
      inspector.all.should be_true
      inspector.models.should == []
    end
  end
  
  describe "investigate" do
  end

end
