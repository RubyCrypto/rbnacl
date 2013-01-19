require 'mkmf'
require 'fileutils'

dir_config 'rbnacl_ext'

if have_header("crypto_secretbox.h") && have_library("nacl", "crypto_nacl_base")
  # this is a big hack to get around a library maybe not being linked in.
  # If there can be a better release of libnacl, this can go.
  unless have_library('nacl', 'randombytes')
    File.open('extconf.h', 'a') { |f| f.puts "#define RBNACL_NEED_RANDOM_BYTES 1" }
  else
    File.open('extconf.h', 'a') { |f| f.puts "#define RBNACL_NEED_RANDOM_BYTES 0" }
  end

  create_makefile 'rbnacl_ext'
end
