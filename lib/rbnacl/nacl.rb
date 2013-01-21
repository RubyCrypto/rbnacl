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
    attach_function :crypto_hash_sha256_ref, [:pointer, :string, :long_long], :int

    PUBLICKEYBYTES = 32
    SECRETKEYBYTES = 32
    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_keypair, [:pointer, :pointer], :int
    wrap_function :crypto_box_curve25519xsalsa20poly1305_ref_keypair, :crypto_box_keypair

    NONCEBYTES    = 24
    ZEROBYTES     = 32
    BOXZEROBYTES  = 16
    BEFORENMBYTES = 32
    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_beforenm, [:pointer, :pointer, :pointer], :int
    wrap_function :crypto_box_curve25519xsalsa20poly1305_ref_beforenm, :crypto_box_beforenm

    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_afternm, [:pointer, :pointer, :long_long, :pointer, :pointer], :int
    wrap_function :crypto_box_curve25519xsalsa20poly1305_ref_afternm, :crypto_box_afternm

    attach_function :crypto_box_curve25519xsalsa20poly1305_ref_open_afternm, [:pointer, :pointer, :long_long, :pointer, :pointer], :int
    wrap_function :crypto_box_curve25519xsalsa20poly1305_ref_open_afternm, :crypto_box_open_afternm
  end
end
