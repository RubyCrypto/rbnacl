require 'mkmf'
require 'fileutils'

dir_config 'rbnacl_ext'

if have_header("crypto_secretbox.h")
  create_makefile 'rbnacl_ext'
end
