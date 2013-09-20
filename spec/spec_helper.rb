# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)

include YoutubeEstore

require 'rspec/rails'
require 'hashie'
require 'pry'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

JSON_FIXTURE_DIR = File.expand_path("../fixtures/json", __FILE__)
DATUMS_HASH = Hashie::Mash.new

def Testdatum(datum_name, opts={})
  json_fname = File.join JSON_FIXTURE_DIR, "#{datum_name}.json"
  
  DATUMS_HASH[datum_name] ||= open(json_fname, 'r'){|f| JSON.parse(f.read)}
end

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)
ActiveRecord::Migration.verbose = false


ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|

  config.filter_run_excluding skip: true 
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true

  config.mock_with :rspec
  config.use_transactional_fixtures = true

   # Use color in STDOUT
  config.color_enabled = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

