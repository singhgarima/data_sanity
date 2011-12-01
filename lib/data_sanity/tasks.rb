namespace :db do
  namespace :data_sanity do
    desc 'Create data inspector model for data sanity results'
    task :migrate => :environment do
      Dir.chdir("#{Rails.root}") do
        system "rails g migration DataInspector table_name:string table_primary_key:string primary_key_value:string validation_errors:text"
      end
    end

    desc 'Destroy data inspector model for data sanity results'
    task :rollback do
      Dir.chdir("#{Rails.root}") do
        system "rails destroy migration DataInspector"
      end
    end
  end
end
