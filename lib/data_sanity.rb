require "rails"

SOURCE_PATH = File.dirname(__FILE__)

require SOURCE_PATH + "/data_sanity/inspector"
require SOURCE_PATH + "/data_sanity/railtie"
require SOURCE_PATH + "/data_sanity/models/data_inspector"
require SOURCE_PATH + "/data_sanity/version"
