# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


Minitest::Reporters.use!([Minitest::Reporters::DefaultReporter.new(colot: true), Minitest::Reporters::SpecReporter.new], ENV, Minitest.backtrace_filter)
