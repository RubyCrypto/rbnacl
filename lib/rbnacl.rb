# encoding: binary
# frozen_string_literal: true

if defined?(RBNACL_LIBSODIUM_GEM_LIB_PATH)
  raise "rbnacl-libsodium is not supported by rbnacl 6.0+. "\
        "Please remove it as a dependency and install libsodium using your system package manager. "\
        "See https://github.com/RubyCrypto/rbnacl#installation"
end

require "rbnacl/version"
require "rbnacl/sodium"
require "rbnacl/sodium/version"
require "rbnacl/serializable"
require "rbnacl/key_comparator"
require "rbnacl/auth"
require "rbnacl/util"
require "rbnacl/random"
require "rbnacl/simple_box"
require "rbnacl/test_vectors"
require "rbnacl/init"
require "rbnacl/aead/base"

# NaCl/libsodium for Ruby
module RbNaCl
  # Oh no, something went wrong!
  #
  # This indicates a failure in the operation of a cryptographic primitive such
  # as authentication failing on an attempt to decrypt a ciphertext.  Classes
  # in the library may define more specific subclasses.
  class CryptoError < StandardError; end

  # Something, probably a key, is the wrong length
  #
  # This indicates some argument with an expected length was not that length.
  # Since this is probably a cryptographic key, you should check that!
  class LengthError < ArgumentError; end

  # An incorrect primitive has been passed to a method
  #
  # This indicates that an attempt has been made to use something (probably a key)
  # with an incorrect primitive
  class IncorrectPrimitiveError < ArgumentError; end

  # The signature was forged or otherwise corrupt
  class BadSignatureError < CryptoError; end

  # The authenticator was forged or otherwise corrupt
  class BadAuthenticatorError < CryptoError; end

  # Public Key Encryption (Box): Curve25519XSalsa20Poly1305
  require "rbnacl/boxes/curve25519xsalsa20poly1305"
  require "rbnacl/boxes/curve25519xsalsa20poly1305/private_key"
  require "rbnacl/boxes/curve25519xsalsa20poly1305/public_key"

  # Sealed boxes
  require "rbnacl/boxes/sealed"

  # Secret Key Encryption (SecretBox): XSalsa20Poly1305
  require "rbnacl/secret_boxes/xsalsa20poly1305"

  # Digital Signatures: Ed25519
  require "rbnacl/signatures/ed25519"
  require "rbnacl/signatures/ed25519/signing_key"
  require "rbnacl/signatures/ed25519/verify_key"

  # Group Elements: Curve25519
  require "rbnacl/group_elements/curve25519"

  # One-time Authentication: Poly1305
  require "rbnacl/one_time_auths/poly1305"

  # Hash functions: SHA256/512 and Blake2b
  require "rbnacl/hash"
  require "rbnacl/hash/sha256"
  require "rbnacl/hash/sha512"
  require "rbnacl/hash/blake2b"

  # Password hash functions
  require "rbnacl/password_hash"
  require "rbnacl/password_hash/scrypt"
  require "rbnacl/password_hash/argon2" if RbNaCl::Sodium::Version::ARGON2_SUPPORTED

  # HMAC: SHA256/512 and SHA512256
  require "rbnacl/hmac/sha256"
  require "rbnacl/hmac/sha512256"
  require "rbnacl/hmac/sha512"

  # AEAD: ChaCha20-Poly1305
  require "rbnacl/aead/chacha20poly1305_legacy"
  require "rbnacl/aead/chacha20poly1305_ietf"
  require "rbnacl/aead/xchacha20poly1305_ietf"

  #
  # Bind aliases used by the public API
  #
  Box          = Boxes::Curve25519XSalsa20Poly1305
  PrivateKey   = Boxes::Curve25519XSalsa20Poly1305::PrivateKey
  PublicKey    = Boxes::Curve25519XSalsa20Poly1305::PublicKey
  SealedBox    = Boxes::Sealed
  SecretBox    = SecretBoxes::XSalsa20Poly1305
  SigningKey   = Signatures::Ed25519::SigningKey
  VerifyKey    = Signatures::Ed25519::VerifyKey
  GroupElement = GroupElements::Curve25519
  OneTimeAuth  = OneTimeAuths::Poly1305
end

# Select platform-optimized versions of algorithms
RbNaCl::Init.sodium_init

# Perform self test on load
require "rbnacl/self_test" unless defined?($RBNACL_SELF_TEST) && $RBNACL_SELF_TEST == false
