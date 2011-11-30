require 'spec_helper'

describe "Generators::DataSanity::DataSanityGenerator" do
  it "should generate a migration in the rails application" do

    Dir["spec/support/sample_app/db/migrate/*_create_data_sanity.rb"].should be_empty
    Generators::DataSanity::DataSanityGenerator.new.create_migration_file
    Dir["spec/support/sample_app/db/migrate/*_create_data_sanity.rb"].count.should == 1
  end
end
