#!/usr/bin/env ruby
require 'ffi'
module Crypto
  # This module has all the FFI code hanging off it
  #
  # And that's all it does, really.
  module NaCl
    extend FFI::Library
    ffi_lib 'sodium'

    SHA256_BYTES = 32
    attach_function :crypto_hash_sha256_ref, [:pointer, :string, :int], :int
    PUBLICKEYBYTES = 32
    SECRETKEYBYTES = 32
    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_keypair, [:pointer, :pointer], :int
  end
end
