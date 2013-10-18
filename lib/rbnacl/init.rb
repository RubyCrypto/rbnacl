# encoding: binary
module RbNaCl
  # Defines the libsodium init function
  module Init
    extend FFI::Library
    ffi_lib 'sodium'

    attach_function :sodium_init, [], :int
  end
end
