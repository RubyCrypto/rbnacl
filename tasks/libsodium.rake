require "rake/clean"

file "libsodium" do
  sh "git clone git://github.com/jedisct1/libsodium.git"
end

file "libsodium/Makefile.in" => "libsodium" do
  sh "cd libsodium && ./autogen.sh"
end

file "libsodium/Makefile" => "libsodium/Makefile.in" do
  sh "cd libsodium && ./configure"
end

file "libsodium/src/libsodium/.libs/libsodium.a" => "libsodium/Makefile" do
  sh "cd libsodium && make"
end

CLEAN.add "libsodium"