# encoding: binary
# frozen_string_literal: true

module RbNaCl
  # Defines the libsodium init function
  module Init
    extend FFI::Library

    sodium_paths = ["sodium", "libsodium.so.18", "libsodium.so.23"]

    if ENV["RBNACL_LIBSODIUM_PATH"]
      sodium_paths.prepend(ENV["RBNACL_LIBSODIUM_PATH"])
    end

    ffi_lib sodium_paths

    attach_function :sodium_init, [], :int
  end
end
