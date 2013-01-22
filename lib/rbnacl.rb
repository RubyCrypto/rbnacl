require "rbnacl/nacl"
require "rbnacl/version"
require "rbnacl/keys"
require "rbnacl/box"
require "rbnacl/secret_box"
require "rbnacl/hash"
require "rbnacl/util"
require "rbnacl/auth"
require "rbnacl/auth/hmac_sha512256"
require "rbnacl/auth/hmac_sha256"

module Crypto
  class CryptoError < StandardError; end
end
