require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'

RSpec::Core::RakeTask.new :spec
task :default => %w(ci:setup:rspec spec)
