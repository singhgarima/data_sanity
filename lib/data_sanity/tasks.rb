namespace :db do
  namespace :data_sanity do
    desc 'Create data inspector model for data sanity results'
    task :migrate => :environment do
      Dir.chdir("#{Rails.root}") do
        system "rails g model DataInspector table_name:string primary_key:string primary_key_value:string errors:text"
      end
    end

    desc 'Destroy data inspector model for data sanity results'
    task :rollback do
      Dir.chdir("#{Rails.root}") do
        system "rails destroy model DataInspector"
      end
    end
  end
end
