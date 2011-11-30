class CreateDataSanity < ActiveRecord::Migration
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
