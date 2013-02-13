module Crypto
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
end

require "rbnacl/nacl"
require "rbnacl/version"
require "rbnacl/keys/key_comparator"
require "rbnacl/keys/private_key"
require "rbnacl/keys/public_key"
require "rbnacl/keys/signing_key"
require "rbnacl/keys/verify_key"
require "rbnacl/box"
require "rbnacl/secret_box"
require "rbnacl/hash"
require "rbnacl/util"
require "rbnacl/auth/hmac_sha512256"
require "rbnacl/auth/hmac_sha256"
require "rbnacl/auth/one_time"
require "rbnacl/random"
require "rbnacl/encoder"
require "rbnacl/encoders/base64"
require "rbnacl/encoders/hex"
require "rbnacl/encoders/raw"
require "rbnacl/point"
require "rbnacl/random_nonce_box"
