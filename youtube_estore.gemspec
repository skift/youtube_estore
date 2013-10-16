$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "youtube_estore/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "youtube_estore"
  s.version     = YoutubeEstore::VERSION
  s.authors     = ["Dan Nguyen"]
  s.email       = ["dansonguyen@gmail.com"]
  s.homepage    = "http://github.com/skift"
  s.summary     = "My engine"
  s.description = "My engine"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  s.add_dependency 'hashie'

#  s.add_dependency 'estore_conventions',
  s.add_dependency 'active_record_content_blob'


  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry-rails"
  s.add_development_dependency 'database_cleaner', '=1.0.1'
  s.add_dependency 'paper_trail', '>= 3.0.0.beta1'


  s.add_development_dependency "timecop"
  s.add_development_dependency "mysql2"
end
