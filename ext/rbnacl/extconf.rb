require 'mkmf'
require 'fileutils'

def ohai(something, tty = STDERR)
  tty.puts "\033[1;34m*** \033[1;39m#{something}\033[0m"
end

dir_config 'rbnacl_ext'

ohai "Building NaCl... this may take awhile"

NACL_SRC = File.expand_path("../../cnacl", __FILE__)
NACL_TMP = NACL_SRC + "/cbuild"

FileUtils.rm_r(NACL_TMP) if File.exists?(NACL_TMP)
FileUtils.mkdir NACL_TMP

system "cd #{NACL_TMP} && cmake #{NACL_SRC}"
system "cd #{NACL_TMP} && make"

$libs << " #{NACL_TMP}/libnacl.a"

create_makefile 'rbnacl_ext'
