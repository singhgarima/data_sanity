require 'spec_helper'

describe "Generators::DataSanity::DataSanityGenerator" do
  it "should generate a migration in the rails application" do
    Dir["spec/support/sample_app/db/migrate/*_create_data_sanity.rb"].should be_empty

    Generators::DataSanity::DataSanityGenerator.new.create_migration_file

    file = Dir["spec/support/sample_app/db/migrate/*_create_data_sanity.rb"]
    file.count.should == 1
    File.open(file.first).read.should == migration_text
  end

  def migration_text
    "class CreateDataSanity < ActiveRecord::Migration
  def self.up
    create_table :data_sanity, :force => true do |t|
      t.string :table_name
      t.string :primary_key
      t.string :primary_key_value
      t.text :errors

      t.timestamps
    end

    add_index :data_sanity, :table_name
  end

  def self.down
    drop_table :data_sanity
  end
end
"
  end
end
