require 'rake'
require 'rake/clean'
require 'digest/sha2'

LIBSODIUM_VERSION = "0.2"

def sh_hidden(command)
  STDERR.puts("*** Executing: #{command}")
  output = `#{command}`

  if !$?.success?
    STDERR.puts "!!! Error executing: #{command}"
    STDERR.puts output
    exit 1
  end
end

libsodium_tarball = "libsodium-#{LIBSODIUM_VERSION}.tar.gz"

file libsodium_tarball do
  sh "curl -L -o #{libsodium_tarball} https://github.com/jedisct1/libsodium/archive/#{LIBSODIUM_VERSION}.tar.gz"

  digest = Digest::SHA256.hexdigest(File.read(libsodium_tarball))
  if digest != "4481748d35319826918afe0edd2d3440b78fa83fb0b0a67c6bd691d88cfcd06b"
    rm libsodium_tarball
    raise "#{libsodium_tarball} failed checksum!"
  end
end

file "libsodium" => "libsodium-#{LIBSODIUM_VERSION}.tar.gz" do
  sh "tar xzf libsodium-#{LIBSODIUM_VERSION}.tar.gz"
  mv "libsodium-#{LIBSODIUM_VERSION}", "libsodium"
end

file "libsodium/Makefile" => "libsodium" do
  sh_hidden "cd libsodium && ./autogen.sh && ./configure"
end

file "libsodium/src/libsodium/.libs/libsodium.a" => "libsodium/Makefile" do
  sh_hidden "cd libsodium && make"
end

if `uname` == 'Darwin'
  libsodium_lib = "libsodium.bundle"
else
  libsodium_lib = "libsodium.so"
end

file "libsodium/src/libsodium/.libs/#{libsodium_lib}" => "libsodium/src/libsodium/.libs/libsodium.a"

task :build_libsodium => "libsodium/src/libsodium/.libs/#{libsodium_lib}" do
  $LIBSODIUM_PATH = "libsodium/src/libsodium/.libs/#{libsodium_lib}"
end

CLEAN.add "libsodium", "libsodium-*.tar.gz"