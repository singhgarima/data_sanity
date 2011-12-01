def clean_data_inspector_migration
  Dir.chdir("#{Rails.root}") do
    system "rake db:rollback"
    system "rake db:data_sanity:rollback"
  end
end

def setup_sample_app
  Dir.chdir("#{Rails.root}") do
    system "bundle"
    system "rake db:reset"
  end
end

def setup_data_inspector
  Dir.chdir("#{Rails.root}") do
    system "rake db:data_sanity:migrate"
    system "rake db:migrate"
  end
  require "#{Rails.root}/app/models/data_inspector"
end
