# encoding: binary
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

        extend  Sodium

        sodium_type      :sign
        sodium_primitive :ed25519

        sodium_function  :sign_ed25519_open,
                         :crypto_sign_ed25519_open,
                         [:pointer, :pointer, :pointer, :ulong_long, :pointer]

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
        # @param signature [String] Alleged signature to be checked
        # @param message [String] Message to be authenticated
        #
        # @return [Boolean] was the signature authentic?
        def verify(signature, message)
          signature = signature.to_str
          Util.check_length(signature, signature_bytes, "signature")

          sig_and_msg = signature + message
          buffer = Util.zeros(sig_and_msg.bytesize)
          buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

          self.class.sign_ed25519_open(buffer, buffer_len, sig_and_msg, sig_and_msg.bytesize, @key)
        end

        # Verify a signature for a given message or raise exception
        #
        # "Dangerous" (but really safer) verify that raises an exception if a
        # signature check fails. This is probably less likely to go unnoticed than
        # an improperly checked verify, as you are forced to deal with the
        # exception explicitly (and failing signature checks are certainly an
        # exceptional condition!)
        #
        # The arguments are otherwise the same as the verify method.
        #
        # @param message [String] Message to be authenticated
        # @param signature [String] Alleged signature to be checked
        #
        # @return [true] Will raise BadSignatureError if signature check fails
        def verify!(message, signature)
          verify(message, signature) or raise BadSignatureError, "signature was forged/corrupt"
        end

        # Return the raw key in byte format
        #
        # @return [String] raw key as bytes
        def to_bytes; @key; end

        # The crypto primitive this VerifyKey class uses for signatures
        #
        # @return [Symbol] The primitive
        def primitive; self.class.primitive; end

        # The size of signatures verified by the VerifyKey class
        #
        # @return [Integer] The number of bytes in a signature
        def self.signature_bytes; Ed25519::SIGNATUREBYTES; end

        # The size of signatures verified by the VerifyKey instance
        #
        # @return [Integer] The number of bytes in a signature
        def signature_bytes; Ed25519::SIGNATUREBYTES; end
      end
    end
  end
end
