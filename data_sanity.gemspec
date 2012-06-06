# -*- encoding: utf-8 -*-
require File.expand_path('../lib/data_sanity/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Habibullah, Rahul, Jigyasa, Jyotsna, Hephzibah, Garima"]
  gem.email = ["igarimasingh@gmail.com"]
  gem.description = %q{Gem for checking data sanity}
  gem.summary = %q{Gem for checking data sanity}
  gem.homepage = "https://github.com/singhgarima/data_sanity"

  gem.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name = "data_sanity"
  gem.require_paths = ["lib"]
  gem.version = DataSanity::VERSION
  gem.license = 'MIT'
end
