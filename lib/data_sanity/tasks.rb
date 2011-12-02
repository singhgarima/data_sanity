namespace :db do
  namespace :data_sanity do
    desc 'Create data inspector model for data sanity results'
    task :migrate => :environment do
      Dir.chdir("#{Rails.root}") do
        system "rails g migration create_data_inspector"
        system "rails g migration add_columns_to_data_inspector table_name:string table_primary_key:string primary_key_value:string validation_errors:text"
      end
    end

    desc 'Destroy data inspector model for data sanity results'
    task :rollback do
      Dir.chdir("#{Rails.root}") do
        system "rails destroy migration add_columns_to_data_inspector"
        system "rails destroy migration create_data_inspector"
      end
    end
  end
end
