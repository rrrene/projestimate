# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wbs_activity_completion/version'

Gem::Specification.new do |gem|
  gem.name = 'wbs_activity_completion'
  gem.version = WbsActivityCompletion::VERSION
  gem.authors = 'Spirula'
  gem.email = 'contact@estimancy.com'
  gem.description = 'The module purpose is to complete some estimation module in order to have a complete WBS-Activity (i.e. a value for each WBS-activity-elements, in the hypothesis where an other module leave some activities not valued).'
  gem.summary = 'Add a way to valued manually added activities (i.e. activities not included on the WBS-activities template) for ProjEstimate'
  gem.license = 'AGPL-3'
  gem.homepage = 'httpforge.estimancy.comorg/'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = 'lib'
end
