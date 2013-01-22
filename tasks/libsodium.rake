require "rake/clean"

file "libsodium-0.1.tar.gz" do
  sh "wget http://download.dnscrypt.org/libsodium/releases/libsodium-0.1.tar.gz"
end

file "libsodium" => "libsodium-0.1.tar.gz" do
  sh "tar xzf libsodium-0.1.tar.gz"
end

file "libsodium/Makefile" => "libsodium" do
  sh "cd libsodium && ./configure"
end

file "libsodium/src/libsodium/.libs/libsodium.a" => "libsodium/Makefile" do
  sh "cd libsodium && make"
end

file "libsodium/src/libsodium/.libs/libsodium.so" => "libsodium/src/libsodium/.libs/libsodium.a"

CLEAN.add "libsodium"
