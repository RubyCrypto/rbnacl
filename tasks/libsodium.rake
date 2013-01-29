require "rake/clean"

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

file "libsodium-#{LIBSODIUM_VERSION}.tar.gz" do
  sh "curl -O http://download.dnscrypt.org/libsodium/releases/libsodium-#{LIBSODIUM_VERSION}.tar.gz"
end

file "libsodium" => "libsodium-#{LIBSODIUM_VERSION}.tar.gz" do
  sh "tar xzf libsodium-#{LIBSODIUM_VERSION}.tar.gz"
  mv "libsodium-#{LIBSODIUM_VERSION}", "libsodium"
end

file "libsodium/Makefile" => "libsodium" do
  sh_hidden "cd libsodium && ./configure"
end

file "libsodium/src/libsodium/.libs/libsodium.a" => "libsodium/Makefile" do
  sh_hidden "cd libsodium && make"
end

file "libsodium/src/libsodium/.libs/libsodium.so" => "libsodium/src/libsodium/.libs/libsodium.a"

CLEAN.add "libsodium", "libsodium-*.tar.gz"
