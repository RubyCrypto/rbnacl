#!/usr/bin/env ruby
require 'ffi'
module Crypto
  # This module has all the FFI code hanging off it
  #
  # And that's all it does, really.
  module NaCl
    extend FFI::Library
    ffi_lib 'sodium'

    def self.wrap_function(function, name)
      module_eval <<-eos, __FILE__, __LINE__ + 1
      def self.#{name}(*args)
        ret = #{function}(*args)
        ret == 0
      end
      eos
    end

    SHA256BYTES = 32
    attach_function :crypto_hash_sha256_ref, [:pointer, :string, :int], :int

    PUBLICKEYBYTES = 32
    SECRETKEYBYTES = 32
    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_keypair, [:pointer, :pointer], :int
    wrap_function :crypto_box_curve25519xsalsa20poly1305_ref_keypair, :crypto_box_keypair
  end
end
