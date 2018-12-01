# encoding: binary
# frozen_string_literal: true

module RbNaCl
  # Defines the libsodium init function
  module Init
    extend FFI::Library
    ffi_lib ["sodium", "libsodium.so.18", "libsodium.so.23"]

    attach_function :sodium_init, [], :int
  end
end
