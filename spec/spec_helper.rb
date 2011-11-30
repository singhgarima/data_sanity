require 'data_sanity'

require 'support/sample_app/config/environment'

Dir.chdir('./spec/support/sample_app') do
  system "rm #{Dir["db/migrate/*_create_data_sanity.rb"].join(" ")}"
  system "rake db:reset && rake db:seed"
end

RSpec::configure do |config|
  config.color_enabled = true
  config.run_all_when_everything_filtered = true
end

