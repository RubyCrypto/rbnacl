# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module Signatures
    # The EdDSA signature system implemented using the Ed25519 elliptic curve
    module Ed25519
      extend Sodium

      sodium_type      :sign
      sodium_primitive :ed25519
      sodium_constant  :SEEDBYTES
      sodium_constant  :PUBLICKEYBYTES, name: :VERIFYKEYBYTES
      sodium_constant  :SECRETKEYBYTES, name: :SIGNINGKEYBYTES
      sodium_constant  :BYTES,          name: :SIGNATUREBYTES
    end
  end
end
