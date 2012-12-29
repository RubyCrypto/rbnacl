require 'mkmf'
require 'fileutils'

dir_config 'rbnacl_ext'

if have_header("crypto_secretbox.h") && have_library("nacl", "crypto_nacl_base")
  create_makefile 'rbnacl_ext'
end
