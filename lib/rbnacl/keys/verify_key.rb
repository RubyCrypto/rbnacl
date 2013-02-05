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
    # Create a new VerifyKey object from a serialized public key. The key can
    # be decoded from any serialization format supported by the
    # Crypto::Encoding system.
    #
    # @param key [String] Serialized Ed25519 public key
    # @param encoding [Symbol] Parse key from the given encoding
    #
    # @return [Crypto::SigningKey] Key which can sign messages
    def initialize(key, encoding = :raw)
      key = Encoder[encoding].decode(key)

      if key.bytesize != NaCl::PUBLICKEYBYTES
        raise ArgumentError, "key must be exactly #{NaCl::PUBLICKEYBYTES} bytes"
      end

      @key = key
    end

    # Create a new VerifyKey object from a serialized public key. The key can
    # be decoded from any serialization format supported by the
    # Crypto::Encoding system.
    #
    # You can remember the argument ordering by "verify message with signature"
    # It's like a legal document, with the signature at the end.
    #
    # @param message [String] Message to be authenticated
    # @param signature [String] Alleged signature to be checked
    # @param signature_encoding [Symbol] Parse signature from the given encoding
    #
    # @return [Boolean] was the signature authentic?
    def verify(message, signature, signature_encoding = :raw)
      signature = Encoder[signature_encoding].decode(signature)

      if signature.bytesize != NaCl::SIGNATUREBYTES
        raise ArgumentError, "signature must be exactly #{NaCl::SIGNATUREBYTES} bytes"
      end

      sig_and_msg = signature + message
      buffer = Util.zeros(sig_and_msg.bytesize)
      buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

      NaCl.crypto_sign_open(buffer, buffer_len, sig_and_msg, sig_and_msg.bytesize, @key)
    end

    # "Dangerous" (but probably safer) verify that raises an exception if a
    # signature check fails. This is probably less likely to go unnoticed than
    # an improperly checked verify, as you are forced to deal with the
    # exception explicitly (and failing signature checks are certainly an
    # exceptional condition!)
    #
    # The arguments are otherwise the same as the verify method.
    #
    # @param message [String] Message to be authenticated
    # @param signature [String] Alleged signature to be checked
    # @param signature_encoding [Symbol] Parse signature from the given encoding
    #
    # @return [true] Will raise BadSignatureError if signature check fails
    def verify!(message, signature, signature_encoding = :raw)
      verify(message, signature, signature_encoding) or raise BadSignatureError, "signature was forged/corrupt"
    end

    # Return the raw key in byte format
    #
    # @return [String] raw key as bytes
    def to_bytes; @key; end

    # Return a string representation of this key, possibly encoded into a
    # given serialization format.
    #
    # @param encoding [Symbol] string encoding format in which to encode the key
    #
    # @return [String] key encoded in the specified format
    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<#{self.class}:#{to_s(:hex)}>"
    end
  end
end
