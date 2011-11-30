require "rails/generators"

module Generators
  module DataSanity
    class DataSanityGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_migration_file
        create_file "#{Rails.root}/db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_data_sanity.rb", File.open("#{Generators::DataSanity::DataSanityGenerator.source_root}/migration.rb").read
      end
    end
  end
end
