# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sample_model/version'

Gem::Specification.new do |gem|
  gem.name          = 'sample_model'
  gem.version       = SampleModel::VERSION
  gem.authors       = 'Spirula'
  gem.email         = 'contact@estimancy.com'
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.license = 'AGPL-3'
  gem.homepage = 'httpforge.estimancy.comorg/'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
