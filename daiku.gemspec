$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "daiku/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "daiku"
  s.version     = Daiku::VERSION
  s.authors     = ["akicho8"]
  s.email       = ["akicho8@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of Daiku."
  s.description = "Description of Daiku."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.org"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "compass-rails"

  # s.add_dependency "jquery-rails"
  # s.add_dependency "coffee-rails"
  # s.add_dependency "coffee-views"
  # s.add_dependency "sass-rails"
  # s.add_dependency "slim-rails"

  s.add_development_dependency "sqlite3"
  # s.add_development_dependency "twitter-bootstrap-rails"
end
