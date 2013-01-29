module Crypto
  class CryptoError < StandardError; end
end

require "rbnacl/nacl"
require "rbnacl/version"
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
require "rbnacl/encoders/hex"