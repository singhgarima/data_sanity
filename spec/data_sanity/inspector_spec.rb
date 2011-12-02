require 'spec_helper'


describe "DataSanity::Inspector" do

  describe "initialize" do
    it "should set all switch as default options and populate all models of the applications" do
      inspector = DataSanity::Inspector.new
      inspector.all.should be_true
      inspector.models.should == ["Person"]
    end

    it "should set random switch, populate default records_per_model and populate all models of the applications" do
      inspector = DataSanity::Inspector.new :validate => :random
      inspector.random.should be_true
      inspector.records_per_model.should == 1
      inspector.models.should == ["Person"]
    end

    it "should set random switch, populate records_per_model and populate all models of the applications" do
      inspector = DataSanity::Inspector.new :validate => :random, :records_per_model => 5
      inspector.random.should be_true
      inspector.records_per_model.should == 5
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

    describe "all" do

      it "should check for errors on the model and populate fields in DataInspector" do
        inspector = DataSanity::Inspector.new

        Person.new(:name => "Valid-Record", :age => 20).save(:validate => false)
        Person.new(:age => 1).save(:validate => false)

        inspector.investigate
        DataInspector.count.should == 1

        first_person = Person.find_by_age(1)
        first_person.valid?
        DataInspector.first.table_name.should == "Person"
        DataInspector.first.table_primary_key.should == "id"
        DataInspector.first.primary_key_value.should == first_person.id.to_s
        YAML.load(DataInspector.first.validation_errors).should == first_person.errors.full_messages
      end
    end

    describe "random" do
      it "should check for errors on the model and populate fields in DataInspector" do
        inspector = DataSanity::Inspector.new(:validate => :random, :records_per_model => 2)

        Person.new(:name => "Valid-Record").save(:validate => false)
        Person.new(:name => "UnderAge", :age => 1).save(:validate => false)
        Person.new(:age => 20).save(:validate => false)
        Person.new(:age => 1).save(:validate => false)

        inspector.investigate
        DataInspector.count.should == 2
      end
    end

    after :each do
      clean_data_inspector_migration
    end
  end

end
