$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "uos/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "uos"
  s.version     = Uos::VERSION
  s.authors     = ["Projestimate"]
  s.email       = ["contact@projestimate.org"]
  s.homepage    = "www.projestimate.org"
  s.summary     = "Summary of Uos."
  s.description = "Description of Uos."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
