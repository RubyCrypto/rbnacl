# encoding: binary
module RbNaCl
  # Defines the libsodium init function
  module Init
    extend FFI::Library
    if defined?(RBNACL_LIBSODIUM_GEM_LIB_PATH)
      ffi_lib RBNACL_LIBSODIUM_GEM_LIB_PATH
    else
      ffi_lib 'sodium'
    end

    attach_function :sodium_init, [], :int
  end
end
