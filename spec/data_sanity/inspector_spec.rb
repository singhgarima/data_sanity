require 'spec_helper'


describe "DataSanity::Inspector" do

  describe "initialize" do
    it "should set all switch as default options and populate all models of the applications" do
      inspector = DataSanity::Inspector.new
      inspector.all.should be_true
      inspector.models.should == ["Car", "Person"]
    end

    it "should set random switch, populate default records_per_model and populate all models of the applications" do
      inspector = DataSanity::Inspector.new :validate => "random"
      inspector.random.should be_true
      inspector.records_per_model.should == 1
      inspector.models.should == ["Car", "Person"]
    end

    it "should set random switch, populate records_per_model and populate all models of the applications" do
      inspector = DataSanity::Inspector.new :validate => "random", :records_per_model => 5
      inspector.random.should be_true
      inspector.records_per_model.should == 5
      inspector.models.should == ["Car", "Person"]
    end
  end

  describe "investigate" do
    before :each do
      setup_data_inspector
    end

    describe "all" do

      it "should check for models with no data" do
        inspector = DataSanity::Inspector.new
        inspector.investigate
        DataInspector.count.should == 0
      end

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

      it "should check for errors on the model and populate fields in DataInspector even if valid? raises exception" do
        inspector = DataSanity::Inspector.new

        exception = Exception.new

        booming_mock = mock(:person)
        booming_mock.should_receive(:valid?).and_raise(exception)
        Person.should_receive(:all).and_return([booming_mock])

        inspector.investigate
        DataInspector.count.should == 1

        YAML.load(DataInspector.first.validation_errors).should_not be_blank
      end
    end

    describe "random" do
      it "should check for models with no data" do
        inspector = DataSanity::Inspector.new :validate => "random"
        inspector.investigate
        DataInspector.count.should == 0
      end

      it "should check for errors on the model and populate fields in DataInspector" do
        inspector = DataSanity::Inspector.new(:validate => "random", :records_per_model => 2)

        Person.new(:name => "InValid-Record").save(:validate => false)
        Person.new(:name => "UnderAge", :age => 1).save(:validate => false)
        Person.new(:age => 20).save(:validate => false)
        Person.new(:age => 1).save(:validate => false)

        inspector.investigate
        DataInspector.count.should == 2
      end

      it "should select minimum of records_per_model and records matching a criteria" do
        inspector = DataSanity::Inspector.new(:validate => "random", :records_per_model => 20)

        Person.new(:name => "InValid-Record").save(:validate => false)

        inspector.investigate
        DataInspector.count.should == 1
      end

      describe "criteria" do
        before :each do
          setup_data_sanity_criteria
        end

        it "should check for models with no data" do
          inspector = DataSanity::Inspector.new :validate => "random"
          inspector.investigate
          DataInspector.count.should == 0
        end

        it "should check for errors on model based on criteria picked from data_sanity_criteria.yml" do
          inspector = DataSanity::Inspector.new(:validate => "random")

          2.times { Person.new(:name => "Raju").save(:validate => false) }
          2.times { Person.new(:name => "Saju").save(:validate => false) }
          2.times { Car.new(:name => "Santro").save(:validate => false) }
          Person.new(:age => 20).save(:validate => false)
          Car.new(:name => "800", :make => "Maruti", :color => "Black", :person => Person.first).save(:validate => false)
          Car.new(:name => "Santro", :make => "HHH", :color => "NotAColor", :person => Person.last).save(:validate => false)

          inspector.investigate
          DataInspector.count.should == 2
          DataInspector.all.collect(&:table_name).should == ["Person", "Person"]
        end

        it "should check all distinct values of field for which a criteria exists" do
          update_data_sanity_criteria(criteria_car_make)
          inspector = DataSanity::Inspector.new(:validate => "random")

          5.times { |i| Car.new(:name => "Car Name#{i}", :make => "Brand1").save(:validate => false) }
          5.times { |i| Car.new(:name => "Car Name#{i}", :make => "Brand2").save(:validate => false) }

          inspector.investigate

          DataInspector.count.should == 2
          DataInspector.all.collect(&:table_name).should == ["Car", "Car"]
          Car.find(DataInspector.first.primary_key_value).make.should == "Brand1"
          Car.find(DataInspector.last.primary_key_value).make.should == "Brand2"
        end

        it "should check all distinct values of field for which a criteria exists" do
          update_data_sanity_criteria(criteria_car_make)
          inspector = DataSanity::Inspector.new(:validate => "random", :records_per_model => "2")

          Car.new(:name => "Car Name1", :make => "Brand1").save(:validate => false)
          Car.new(:name => "Car Name2", :make => "Brand2").save(:validate => false)
          Car.new(:name => "Car Name3", :make => "Brand1").save(:validate => false)
          Car.new(:name => "Car Name4", :make => "Brand2").save(:validate => false)
          Car.new(:name => "Car Name5", :make => "Brand1").save(:validate => false)
          Car.new(:name => "Car Name6", :make => "Brand2").save(:validate => false)
          Car.new(:name => "Car Name7", :make => "Brand3").save(:validate => false)

          inspector.investigate

          DataInspector.count.should == 5
          DataInspector.all.collect(&:table_name).uniq.should == ["Car"]
          Car.find(DataInspector.all.collect(&:primary_key_value)).collect(&:make).sort.should == ["Brand1", "Brand1", "Brand2", "Brand2", "Brand3"]
        end

        it "should select minimum of records_per_model and records matching a criteria" do
          update_data_sanity_criteria(criteria_car_make)
          inspector = DataSanity::Inspector.new(:validate => "random", :records_per_model => "15")

          2.times { |i| Car.new(:name => "Car Name#{i}", :make => "Brand1").save(:validate => false) }
          2.times { |i| Car.new(:name => "Car Name#{i}", :make => "Brand2").save(:validate => false) }

          inspector.investigate

          DataInspector.count.should == 4
        end

        it "should be able to look at multiple criteria" do
          update_data_sanity_criteria(criteria_multiple)
          inspector = DataSanity::Inspector.new(:validate => "random", :records_per_model => "1")

          2.times { |i| Car.new(:name => "Car Name#{i}", :make => "Brand1").save(:validate => false) }
          2.times { Person.new(:name => "Saju").save(:validate => false) }

          inspector.investigate

          DataInspector.count.should == 2
          DataInspector.all.collect(&:table_name).sort.should == ["Person", "Car"].sort
        end

        after :each do
          cleanup_data_sanity_criteria
        end
      end
    end

    after :each do
      clean_data_inspector_migration
    end
  end

  def criteria_car_make
    "Car:
  make"
  end

  def criteria_multiple
    "Car:
Person:"
  end

end
