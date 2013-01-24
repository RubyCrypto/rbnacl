require "rbnacl/nacl"
require "rbnacl/version"
require "rbnacl/keys/private_key"
require "rbnacl/keys/public_key"
require "rbnacl/box"
require "rbnacl/secret_box"
require "rbnacl/hash"
require "rbnacl/util"
require "rbnacl/auth/hmac_sha512256"
require "rbnacl/auth/hmac_sha256"

module Crypto
  class CryptoError < StandardError; end
end
