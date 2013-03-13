# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocomo_basic/version'

Gem::Specification.new do |gem|
  gem.name          = "cocomo_basic"
  gem.version       = CocomoBasic::VERSION
  gem.authors       = ["nicolas"]
  gem.email         = ["renard760@gmail.com"]
  gem.description   = "Cocomo Basic gem"
  gem.summary       = "Cocomo Basic cummary"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
