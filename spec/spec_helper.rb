require 'data_sanity/inspector'
require 'support/sample_app/config/environment'

RSpec::configure do |config|
  config.color_enabled = true
  config.filter_run :focused => true
  config.run_all_when_everything_filtered = true
end

