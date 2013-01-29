require "rake/clean"

def sh_hidden(command)
  STDERR.puts("*** Executing: #{command}")
  output = `#{command}`

  if !$?.success?
    STDERR.puts "!!! Error executing: #{command}"
    STDERR.puts output
    exit 1
  end
end

file "libsodium-0.1.tar.gz" do
  sh "wget http://download.dnscrypt.org/libsodium/releases/libsodium-0.1.tar.gz"
end

file "libsodium" => "libsodium-0.1.tar.gz" do
  sh "tar xzf libsodium-0.1.tar.gz"
  mv "libsodium-0.1", "libsodium"
end

file "libsodium/Makefile" => "libsodium" do
  sh_hidden "cd libsodium && ./configure"
end

file "libsodium/src/libsodium/.libs/libsodium.a" => "libsodium/Makefile" do
  sh_hidden "cd libsodium && make"
end

file "libsodium/src/libsodium/.libs/libsodium.so" => "libsodium/src/libsodium/.libs/libsodium.a"

CLEAN.add "libsodium", "libsodium-0.1.tar.gz"
