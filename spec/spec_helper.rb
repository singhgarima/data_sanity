require 'data_sanity'
require 'support/helper'

require 'support/sample_app/config/environment'

setup_sample_app

RSpec::configure do |config|
  config.color_enabled = true
  config.run_all_when_everything_filtered = true
end

