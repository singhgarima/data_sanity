class Person < ActiveRecord::Base
  validates_presence_of :name, :age
  validates_numericality_of :age, :greater_than => 18
end
