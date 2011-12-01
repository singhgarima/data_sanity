require 'data_sanity'
require 'rails'

module DataSanity
  class Railtie < Rails::Railtie

    rake_tasks do
      load 'data_sanity/tasks.rb'
    end
  end
end
