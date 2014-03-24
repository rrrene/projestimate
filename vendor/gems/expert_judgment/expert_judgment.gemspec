# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'expert_judgment/version'

Gem::Specification.new do |gem|
  gem.name = 'expert_judgment'
  gem.version = ExpertJudgment::VERSION
  gem.authors = 'Spirula'
  gem.email = 'contact@estimancy.com'
  gem.description = 'As a project owner an expert need the capability to fill 3 point-values for each WBS-activity-element (leaf) instancied on the project.'
  gem.summary = 'Implementation of a basic Expert Judgement estimation method for ProjEstimate'
  gem.license = 'AGPL-3'
  gem.homepage = 'httpforge.estimancy.comorg/'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = 'lib'

  #Gem  dependencies: after install, the gem will create migration and run them
  gem.add_development_dependency 'rake'

end
