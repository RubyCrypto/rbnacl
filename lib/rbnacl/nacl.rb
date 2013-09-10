# encoding: binary
require 'ffi'
module RbNaCl
  # This module has all the FFI code hanging off it
  #
  # And that's all it does, really.
  #
  # HERE BE DRAGONS!
  #
  # Do **NOT** use constants and methods defined here.  If you do find yourself
  # needing to, that is a bug in RbNaCl and should be reported.
  #
  # @private
  module NaCl
    extend FFI::Library

    ffi_lib 'sodium'
    attach_function :sodium_version_string, [], :string

    # Determine if a given feature is supported based on Sodium/NaCl version
    def self.supported_version?(engine, version)
      return unless engine == :libsodium

      # FIXME: This sort of comparison has some edge cases we don't have to
      # worry about... yet.
      sodium_version_string >= version
    end

    # Wraps an NaCl function so it returns a sane value
    #
    # The NaCl functions generally have an integer return value which is 0 in
    # the case of success and below 0 if they failed.  This is a bit
    # inconvenient in ruby, where 0 is a truthy value, so this makes them
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
                       [:pointer, :pointer, :long_long]

    SHA512BYTES = 64
    wrap_nacl_function :crypto_hash_sha512,
                       :crypto_hash_sha512_ref,
                       [:pointer, :pointer, :long_long]

    BLAKE2B_OUTBYTES = 64
    BLAKE2B_KEYBYTES = 64
    wrap_nacl_function :crypto_hash_blake2b,
                       :crypto_generichash_blake2b,
                       [:pointer, :size_t, :pointer, :long_long, :pointer, :size_t]

    CURVE25519_XSALSA20_POLY1305_PUBLICKEY_BYTES = 32
    PUBLICKEYBYTES = CURVE25519_XSALSA20_POLY1305_PUBLICKEY_BYTES
    CURVE25519_XSALSA20_POLY1305_SECRETKEY_BYTES = 32
    SECRETKEYBYTES = CURVE25519_XSALSA20_POLY1305_SECRETKEY_BYTES
    wrap_nacl_function :crypto_box_curve25519xsalsa20poly1305_keypair,
                       :crypto_box_curve25519xsalsa20poly1305_ref_keypair,
                       [:pointer, :pointer]

    CURVE25519_XSALSA20_POLY1305_BOX_NONCEBYTES    = 24
    NONCEBYTES     = CURVE25519_XSALSA20_POLY1305_BOX_NONCEBYTES
    ZEROBYTES      = 32
    BOXZEROBYTES   = 16
    CURVE25519_XSALSA20_POLY1305_BOX_BEFORENMBYTES = 32

    wrap_nacl_function :crypto_box_curve25519_xsalsa20_poly1305_beforenm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_beforenm,
                       [:pointer, :pointer, :pointer]

    wrap_nacl_function :crypto_box_curve25519_xsalsa20_poly1305_afternm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_afternm,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    wrap_nacl_function :crypto_box_curve25519_xsalsa20_poly1305_open_afternm,
                       :crypto_box_curve25519xsalsa20poly1305_ref_open_afternm,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    XSALSA20_POLY1305_SECRETBOX_KEYBYTES   = 32
    XSALSA20_POLY1305_SECRETBOX_NONCEBYTES = 24
    wrap_nacl_function :crypto_secretbox_xsalsa20poly1305,
                       :crypto_secretbox_xsalsa20poly1305_ref,
                       [:pointer, :pointer, :long_long, :pointer, :pointer]

    wrap_nacl_function :crypto_secretbox_xsalsa20poly1305_open,
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
    
    ONETIME_KEYBYTES = 32
    ONETIME_BYTES = 16
    if NaCl.supported_version? :libsodium, '0.4.3'
      crypto_onetimeauth_poly1305 = :crypto_onetimeauth_poly1305
      crypto_onetimeauth_poly1305_verify = :crypto_onetimeauth_poly1305_verify
    else
      crypto_onetimeauth_poly1305 = :crypto_onetimeauth_poly1305_ref
      crypto_onetimeauth_poly1305_verify = :crypto_onetimeauth_poly1305_verify_ref
    end

    wrap_nacl_function :crypto_auth_onetime,
                       crypto_onetimeauth_poly1305,
                       [:pointer, :pointer, :long_long, :pointer]
    wrap_nacl_function :crypto_auth_onetime_verify,
                       crypto_onetimeauth_poly1305_verify,
                       [:pointer, :pointer, :long_long, :pointer]

    wrap_nacl_function :random_bytes,
                       :randombytes,
                       [:pointer, :long_long]

    wrap_nacl_function :crypto_verify_32,
                       :crypto_verify_32_ref,
                       [:pointer, :pointer]
    wrap_nacl_function :crypto_verify_16,
                       :crypto_verify_16_ref,
                       [:pointer, :pointer]

    ED25519_SIGNATUREBYTES   = 64
    SIGNATUREBYTES           = ED25519_SIGNATUREBYTES
    ED25519_SIGNINGKEY_BYTES = 64
    ED25519_VERIFYKEY_BYTES  = 32
    ED25519_SEED_BYTES       = 32
    wrap_nacl_function :crypto_sign_ed25519_seed_keypair,
                       :crypto_sign_ed25519_ref_seed_keypair,
                       [:pointer, :pointer, :pointer]

    wrap_nacl_function :crypto_sign_ed25519,
                       :crypto_sign_ed25519_ref,
                       [:pointer, :pointer, :pointer, :long_long, :pointer]

    wrap_nacl_function :crypto_sign_ed25519_open,
                       :crypto_sign_ed25519_ref_open,
                       [:pointer, :pointer, :pointer, :long_long, :pointer]

    ED25519_SCALARBYTES = 32
    SCALARBYTES         = ED25519_SCALARBYTES

    wrap_nacl_function :crypto_scalarmult_curve25519,
                       :crypto_scalarmult_curve25519_ref,
                       [:pointer, :pointer, :pointer]
  end
end
