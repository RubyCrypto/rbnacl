module Crypto
  # The signature was forged or otherwise corrupt
  class BadSignatureError < CryptoError; end

  class VerifyKey
    def initialize(key, encoding = :raw)
      key = Encoder[encoding].decode(key)

      if key.bytesize != NaCl::PUBLICKEYBYTES
        raise ArgumentError, "key must be exactly #{NaCl::PUBLICKEYBYTES} bytes"
      end

      @key = key
    end

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

    def verify!(message, signature, signature_encoding = :raw)
      verify(message, signature, signature_encoding) or raise BadSignatureError, "signature was forged/corrupt"
    end

    def to_bytes; @key; end

    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end

    def inspect
      "#<#{self.class}:#{to_s(:hex)}>"
    end
  end
end