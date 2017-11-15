$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "may_may/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "may_may"
  s.version     = MayMay::VERSION
  s.authors     = ["Without Software (James Roscoe)"]
  s.email       = ["james@withoutsoftware.com"]
  s.homepage    = "http://withoutsoftware.com"
  s.summary     = "Rails Controller action permission management"
  s.description = "Manage controller/action permissions easily in Rails. Returns 403 (Access Denied) unless current user has permission to perform the requested controller action. Easy syntax for use in views to check permission: may?(:action, :controller). Source at https://github.com/without/may_may.git"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]


  s.add_runtime_dependency 'rake'

  s.add_dependency "sqlite3"
  s.add_development_dependency "rails", '~> 5.1.4'
  s.add_development_dependency "jquery-rails"
  s.add_development_dependency 'listen'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-minitest'
  s.add_development_dependency 'guard-rubocop'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'minitest-focus'
  s.add_development_dependency 'awesome_print'

  s.add_development_dependency 'rb-readline'
  s.add_development_dependency 'pry-remote'



end
