# frozen_string_literal: true

require "bundler/gem_tasks"

Dir[File.expand_path("tasks/**/*.rake", __dir__)].each { |task| load task }

task default: %w[spec rubocop]
task ci:      %w[spec rubocop]
