namespace :data_sanity do
  namespace :db do
    desc 'Create data inspector model for data sanity results (runs migration too)'
    task :migrate => :environment do
      Dir.chdir("#{Rails.root}") do
        command = "rails generate model DataInspector table_name:string table_primary_key:string primary_key_value:string validation_errors:text"
        log_command command
        system "#{command}"
        command = "rake db:migrate"
        Rake::Task['db:migrate'].execute
      end
    end

    desc 'Destroy data inspector model for data sanity results (it doesnt rollbacks the migration)'
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

  desc 'Data Sanity run investigation - params[strategy,validate,records_per_model]'
  task :investigate, [:strategy, :validate, :records_per_model] => :environment do |t, args|
    DataSanity::Inspector.new(args).investigate
  end
end

def log_command command
  puts "Running ==> " + command.to_s
end
