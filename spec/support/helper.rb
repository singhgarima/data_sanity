def clean_data_inspector_migration
  Dir.chdir("#{Rails.root}") do
    system "rake db:rollback"
    system "rake data_sanity:db:rollback"
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
    system "rake data_sanity:db:migrate"
  end
end

def setup_data_sanity_criteria
  Dir.chdir("#{Rails.root}") do
    system "rake data_sanity:criteria"
    file = File.open("config/data_sanity_criteria.yml", "w")
    file << template_yml
    file.close
  end
end

def update_data_sanity_criteria(criteria)
  Dir.chdir("#{Rails.root}") do
    file = File.open("config/data_sanity_criteria.yml", "w")
    file << criteria
    file.close
  end
end

def cleanup_data_sanity_criteria
  Dir.chdir("#{Rails.root}") do
    system "rm config/data_sanity_criteria.yml"
  end
end

def template_yml
  "Person:
  name: ['Raju', 'Saju']"
end
