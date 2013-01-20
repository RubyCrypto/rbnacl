require 'mkmf'
require 'fileutils'

dir_config 'rbnacl_ext'

if have_header("sodium/crypto_secretbox.h") && have_library("sodium")
  # this is a big hack to get around a library maybe not being linked in.
  # If there can be a better release of libnacl, this can go.

  create_makefile 'rbnacl_ext'
end
