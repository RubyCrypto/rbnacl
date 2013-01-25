#!/usr/bin/env ruby
require 'ffi'
module Crypto
  # This module has all the FFI code hanging off it
  #
  # And that's all it does, really.
  module NaCl
    extend FFI::Library
    ffi_lib 'sodium'

    # Wraps an NaCl function so it returns a sane value
    #
    # The NaCl functions generally have an integer return value which is 0 in
    # the case of success and below 0 if they failed.  This is a bit
    # inconvinient in ruby, where 0 is a truthy value, so this makes them
    # return true/false based on success.
    #
    # @param [Symbol] name Function name that will return true/false
    # @param [Symbol] function Function to attach
    # @param [Array<Symbol>] arguments Array of arguments to the function
    def self.wrap_nacl_function(name, function, arguments)
      module_eval <<-eos, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        ret = #{function}(*args)
        ret == 0
      end
      eos
    end

    SHA256BYTES = 32
    wrap_nacl_function :crypto_hash_sha256,
                       :crypto_hash_sha256_ref,
                       [:pointer, :string, :long_long]

    PUBLICKEYBYTES = 32
    SECRETKEYBYTES = 32
    wrap_nacl_function :crypto_box_keypair,
                       :crypto_box_curve25519xsalsa20poly1305_ref_keypair,
                       [:pointer, :pointer]

    NONCEBYTES    = 24
    ZEROBYTES     = 32
    BOXZEROBYTES  = 16
    BEFORENMBYTES = 32
    wrap_nacl_function :crypto_box_beforenm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_beforenm,
                       [:pointer, :pointer, :pointer]

    wrap_nacl_function :crypto_box_afternm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_afternm,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    wrap_nacl_function :crypto_box_open_afternm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_open_afternm,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    SECRETBOX_KEYBYTES = 32
    wrap_nacl_function :crypto_secretbox,
                       :crypto_secretbox_xsalsa20poly1305_ref,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    wrap_nacl_function :crypto_secretbox_open,
                       :crypto_secretbox_xsalsa20poly1305_ref_open,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    HMACSHA512256_KEYBYTES = 32
    HMACSHA512256_BYTES = 32
    wrap_nacl_function :crypto_auth_hmacsha512256,
                       :crypto_auth_hmacsha512256_ref,
                       [:pointer, :pointer, :long_long, :pointer]
    wrap_nacl_function :crypto_auth_hmacsha512256_verify,
                       :crypto_auth_hmacsha512256_ref_verify,
                       [:pointer, :pointer, :long_long, :pointer]

    HMACSHA256_KEYBYTES = 32
    HMACSHA256_BYTES = 32
    wrap_nacl_function :crypto_auth_hmacsha256,
                       :crypto_auth_hmacsha256_ref,
                       [:pointer, :pointer, :long_long, :pointer]
    wrap_nacl_function :crypto_auth_hmacsha256_verify,
                       :crypto_auth_hmacsha256_ref_verify,
                       [:pointer, :pointer, :long_long, :pointer]

    wrap_nacl_function :random_bytes,
                       :randombytes,
                       [:pointer, :long_long]

  end
end
