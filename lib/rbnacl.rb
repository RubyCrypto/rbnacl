# encoding: binary
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
end

require "rbnacl/nacl"
require "rbnacl/version"
require "rbnacl/serializable"
require "rbnacl/keys/key_comparator"
require "rbnacl/keys/private_key"
require "rbnacl/keys/public_key"
require "rbnacl/keys/signing_key"
require "rbnacl/keys/verify_key"
require "rbnacl/box"
require "rbnacl/secret_box"
require "rbnacl/hash"
require "rbnacl/hash/blake2b"
require "rbnacl/util"
require "rbnacl/auth"
require "rbnacl/hmac/sha512256"
require "rbnacl/hmac/sha256"
require "rbnacl/auth/one_time"
require "rbnacl/random"
require "rbnacl/point"
require "rbnacl/random_nonce_box"
require "rbnacl/test_vectors"

# Perform self test on load
require "rbnacl/self_test"
