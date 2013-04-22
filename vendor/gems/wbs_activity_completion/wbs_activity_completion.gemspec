# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wbs_activity_completion/version'

Gem::Specification.new do |gem|
  gem.name          = "wbs_activity_completion"
  gem.version       = WbsActivityCompletion::VERSION
  gem.authors       = ["spirula-sga"]
  gem.email         = ["salimata.gaye@spirula.fr"]
  gem.description   = "WBS-Activity Completion module will complete some estimation module in order to have a complete WBS-Activity "
  gem.summary       = "WBS-Activity Completion"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
