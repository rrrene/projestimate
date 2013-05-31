# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sandbox/version'

Gem::Specification.new do |gem|
  gem.name = 'sandbox'
  gem.version = Sandbox::VERSION
  gem.authors = 'Spirula'
  gem.email = 'info@projestimate.org'
  gem.description = 'This is a sample module for testing purpose only'
  gem.summary = 'Implementation of dummy estimation method for ProjEstimate'
  gem.license = 'AGPL-3'
  gem.homepage = 'http://projestimate.org/'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = 'lib'
end
