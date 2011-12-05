class Car < ActiveRecord::Base

  validates_presence_of :name, :make, :color
  validates_inclusion_of :color, :in => [:red, :blue, :black, :green, :white, :silver, :golden]

  belongs_to :person
end
