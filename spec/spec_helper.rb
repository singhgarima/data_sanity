require 'data_sanity/inspector'

Dir['./spec/support/**/*'].each {|f| require f}

RSpec::configure do |config|
  config.color_enabled = true
  config.filter_run :focused => true
  config.run_all_when_everything_filtered = true
end

