require 'rubygems'
require 'bundler/setup'

Dir["../lib/data_sanity/**/*.rb"].each { |file| require file }


RSpec.configure do |config|
  # some (optional) config here
end
