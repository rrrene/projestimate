# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expert_judgment/version'

Gem::Specification.new do |gem|
  gem.name          = "expert_judgment"
  gem.version       = ExpertJudgment::VERSION
  gem.authors       = ["spirula-sga"]
  gem.email         = ["salimata.gaye@spirula.fr"]
  gem.description   = " Expert Judgment gem for estimation module"
  gem.summary       = " Expert Judgment summary"
  #gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  #Gem  dependencies: after install, the gem will create migration and run them
  gem.add_development_dependency 'rake'

end
