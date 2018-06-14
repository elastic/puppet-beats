require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax/tasks/puppet-syntax'


# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

PuppetLint.configuration.log_format = '%{path}:%{line}:%{check}:%{KIND}:%{message}'
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.send('disable_single_quote_string_with_variables')

exclude_paths = %w(
  pkg/**/*
  vendor/**/*
  .vendor/**/*
  spec/**/*
)
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc 'Run all non-acceptance rspec tests.'
RSpec::Core::RakeTask.new(:spec_unit) do |t|
  t.pattern = 'spec/{classes,templates,unit}/**/*_spec.rb'
end
task :spec_unit => :spec_prep

desc 'Run syntax, lint, and spec tests.'
task :test => [
  :lint,
  :rubocop,
  :validate,
  :spec_unit
]
