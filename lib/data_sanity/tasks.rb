namespace :data_sanity do
  namespace :db do
    desc 'Create data inspector model for data sanity results'
    task :migrate => :environment do
      Dir.chdir("#{Rails.root}") do
        system "rails generate model DataInspector table_name:string table_primary_key:string primary_key_value:string validation_errors:text"
      end
    end

    desc 'Destroy data inspector model for data sanity results'
    task :rollback => :environment do
      Dir.chdir("#{Rails.root}") do
        system "rails destroy model DataInspector"
      end
    end
  end

  desc 'Creating a sample criteria file'
  task :criteria do
    Dir.chdir("#{Rails.root}") do
      system "cp #{SOURCE_PATH}/data_sanity/templates/data_sanity_criteria.yml #{Rails.root}/config/."
    end
  end

  desc 'Data Sanity run investigation'
  task :investigate, :validate, :records_per_model do |t, args|
    DataSanity::Inspector.new(args).investigate
  end
end
