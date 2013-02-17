require "rake/clean"

file "lib/libsodium.so" => :build_libsodium do
  cp "libsodium/src/libsodium/.libs/libsodium.so", "lib/libsodium.so"
end

task "ci:sodium" => "lib/libsodium.so"

task :ci => %w(ci:sodium spec)

CLEAN.add "lib/libsodium.*"