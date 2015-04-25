require "bundler/gem_tasks"

Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each { |task| load task }

task default: %w(spec rubocop)
task ci:      %w(spec rubocop)
