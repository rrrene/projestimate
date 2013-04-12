# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'effort_breakdown/version'

Gem::Specification.new do |gem|
  gem.name          = "effort_breakdown"
  gem.version       = EffortBreakdown::VERSION
  gem.authors       = ["spirula-sga"]
  gem.email         = ["salimata.gaye@spirula.fr"]
  gem.description   = "This module distributes the Product global effort to its activities, using the ratio table"
  gem.summary       = "Effort Breakdown"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
