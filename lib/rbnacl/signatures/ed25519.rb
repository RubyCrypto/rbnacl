# encoding: binary
module RbNaCl
  module Signatures
    module Ed25519
      extend Sodium

      sodium_type      :sign
      sodium_primitive :ed25519
      sodium_constant  :SEEDBYTES
      sodium_constant  :PUBLICKEYBYTES, :VERIFYKEYBYTES
      sodium_constant  :SECRETKEYBYTES, :SIGNINGKEYBYTES
      sodium_constant  :BYTES,          :SIGNATUREBYTES
    end
  end
end
