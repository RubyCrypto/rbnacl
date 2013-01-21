require "rbnacl/nacl"
require "rbnacl/version"
require "rbnacl/keys"
require "rbnacl/box"
require "rbnacl/secret_box"
require "rbnacl/hash"
require "rbnacl/util"

module Crypto
  class CryptoError < StandardError; end
end
