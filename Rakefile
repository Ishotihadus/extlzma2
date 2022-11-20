# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'

task build: :compile

Rake::ExtensionTask.new('extlzma2') do |ext|
  ext.lib_dir = 'lib/extlzma2'
end

task default: %i[clobber compile]

RSpec::Core::RakeTask.new(:spec)
