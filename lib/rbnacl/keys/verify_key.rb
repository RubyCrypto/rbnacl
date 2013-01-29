module Crypto
  # The signature was forged or otherwise corrupt
  class BadSignatureError < StandardError; end

  class VerifyKey
    def initialize(key)
      if key.bytesize != NaCl::PUBLICKEYBYTES
        raise ArgumentError, "key must be exactly #{NaCl::PUBLICKEYBYTES} bytes"
      end

      @key = key
    end

    def verify(message, signature)
      if signature.bytesize != NaCl::SIGNATUREBYTES
        raise ArgumentError, "signature must be exactly #{NaCl::SIGNATUREBYTES} bytes"
      end

      sig_and_msg = signature + message
      buffer = Util.zeros(sig_and_msg.bytesize)
      buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

      NaCl.crypto_sign_open(buffer, buffer_len, sig_and_msg, sig_and_msg.bytesize, @key)
    end

    def verify!(message, signature)
      verify(message, signature) or raise BadSignatureError, "signature was forged/corrupt"
    end

    def to_bytes
      @key.dup
    end

    def inspect
      "#<#{self.class}:#{@key.unpack("H*").first}>"
    end
  end
end