require "bundler/gem_tasks"
Dir[File.expand_path("../tasks/**/*.rake", __FILE__)].each { |task| load task }

task :default => %w(compile spec)

task :ci => %w(libsodium/src/libsodium/.libs/libsodium.a compile spec)