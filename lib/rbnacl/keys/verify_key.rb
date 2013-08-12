# encoding: binary
module Crypto
  # The signature was forged or otherwise corrupt
  class BadSignatureError < CryptoError; end

  # The public key counterpart to an Ed25519 SigningKey for producing digital
  # signatures. Like the name says, VerifyKeys can be used to verify that a
  # given digital signature is authentic.
  #
  # For more information on the Ed25519 digital signature system, please see
  # the SigningKey documentation.
  class VerifyKey
    include KeyComparator
    include Serializable

    # Create a new VerifyKey object from a serialized public key.
    #
    # @param key [String] Serialized Ed25519 public key
    #
    # @return [Crypto::SigningKey] Key which can sign messages
    def initialize(key)
      @key = key.to_str
      Util.check_length(@key, NaCl::ED25519_VERIFYKEY_BYTES, "key")
    end

    # Verify a signature for a given message
    #
    # @param message [String] Message to be authenticated
    # @param signature [String] Alleged signature to be checked
    #
    # @return [Boolean] was the signature authentic?
    def verify(message, signature)
      signature = signature.to_str
      Util.check_length(signature, signature_bytes, "signature")

      sig_and_msg = signature + message
      buffer = Util.zeros(sig_and_msg.bytesize)
      buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

      NaCl.crypto_sign_ed25519_open(buffer, buffer_len, sig_and_msg, sig_and_msg.bytesize, @key)
    end

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

    # The crypto primitive the VerifyKey class uses for signatures
    #
    # @return [Symbol] The primitive
    def self.primitive; :ed25519; end

    # The crypto primitive this VerifyKey class uses for signatures
    #
    # @return [Symbol] The primitive
    def primitive; self.class.primitive; end

    # The size of signatures verified by the VerifyKey class
    #
    # @return [Integer] The number of bytes in a signature
    def self.signature_bytes; NaCl::ED25519_SIGNATUREBYTES; end

    # The size of signatures verified by the VerifyKey instance
    #
    # @return [Integer] The number of bytes in a signature
    def signature_bytes; NaCl::ED25519_SIGNATUREBYTES; end
  end
end
