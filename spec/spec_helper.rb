require 'data_sanity'
require 'support/helper'
require 'database_cleaner'

require 'support/sample_app/config/environment'

setup_sample_app

RSpec::configure do |config|
  config.color_enabled = true
  config.run_all_when_everything_filtered = true
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

