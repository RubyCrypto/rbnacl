# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module Signatures
    module Ed25519
      # The public key counterpart to an Ed25519 SigningKey for producing digital
      # signatures. Like the name says, VerifyKeys can be used to verify that a
      # given digital signature is authentic.
      #
      # For more information on the Ed25519 digital signature system, please see
      # the SigningKey documentation.
      class VerifyKey
        include KeyComparator
        include Serializable

        extend Sodium

        sodium_type      :sign
        sodium_primitive :ed25519

        sodium_function  :sign_ed25519_open,
                         :crypto_sign_ed25519_open,
                         %i[pointer pointer pointer ulong_long pointer]

        sodium_function :to_public_key,
                        :crypto_sign_ed25519_pk_to_curve25519,
                        %i[pointer pointer]

        # Create a new VerifyKey object from a public key.
        #
        # @param key [String] Ed25519 public key
        #
        # @return [RbNaCl::VerifyKey] Key which can verify messages
        def initialize(key)
          @key = key.to_str
          Util.check_length(@key, Ed25519::VERIFYKEYBYTES, "key")
        end

        # Verify a signature for a given message
        #
        # Raises if the signature is invalid.
        #
        # @param signature [String] Alleged signature to be checked
        # @param message [String] Message to be authenticated
        #
        # @raise [BadSignatureError] if the signature check fails
        # @raise [LengthError]  if the signature is of the wrong length
        #
        # @return [Boolean] was the signature authentic?
        def verify(signature, message)
          signature = signature.to_str
          Util.check_length(signature, signature_bytes, "signature")
          verify_attached(signature + message)
        end

        # Verify a signature for a given signed message
        #
        # Raises if the signature is invalid.
        #
        # @param signed_message [String] Message combined with signature to be authenticated
        #
        # @raise [BadSignatureError] if the signature check fails
        #
        # @return [Boolean] was the signature authentic?
        def verify_attached(signed_message)
          raise LengthError, "Signed message can not be nil" if signed_message.nil?
          raise LengthError, "Signed message can not be shorter than a signature" if signed_message.bytesize <= signature_bytes

          buffer = Util.zeros(signed_message.bytesize)
          buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

          success = self.class.sign_ed25519_open(buffer, buffer_len, signed_message, signed_message.bytesize, @key)
          raise(BadSignatureError, "signature was forged/corrupt") unless success

          true
        end

        # Return the raw key in byte format
        #
        # @return [String] raw key as bytes
        def to_bytes
          @key
        end

        # The crypto primitive this VerifyKey class uses for signatures
        #
        # @return [Symbol] The primitive
        def primitive
          self.class.primitive
        end

        # The size of signatures verified by the VerifyKey class
        #
        # @return [Integer] The number of bytes in a signature
        def self.signature_bytes
          Ed25519::SIGNATUREBYTES
        end

        # The size of signatures verified by the VerifyKey instance
        #
        # @return [Integer] The number of bytes in a signature
        def signature_bytes
          Ed25519::SIGNATUREBYTES
        end

        # Return a new curve25519 (x25519) public key converted from this key
        #
        # it's recommeneded to read https://libsodium.gitbook.io/doc/advanced/ed25519-curve25519
        # as it encourages using distinct keys for signing and for encryption
        #
        # @return [RbNaCl::PublicKey]
        def to_curve25519_public_key
          buffer = Util.zeros(Boxes::Curve25519XSalsa20Poly1305::PublicKey::BYTES)
          self.class.crypto_sign_ed25519_pk_to_curve25519(buffer, @key)
          Boxes::Curve25519XSalsa20Poly1305::PublicKey.new(buffer)
        end
      end
    end
  end
end
