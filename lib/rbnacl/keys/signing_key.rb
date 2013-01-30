module Crypto
  class SigningKey
    attr_reader :verify_key

    def self.generate
      new Crypto::Random.random_bytes(NaCl::SECRETKEYBYTES)
    end

    def initialize(seed)
      if seed.bytesize != NaCl::SECRETKEYBYTES
        raise ArgumentError, "seed must be exactly #{NaCl::SECRETKEYBYTES} bytes"
      end

      pk = Util.zeros(NaCl::PUBLICKEYBYTES)
      sk = Util.zeros(NaCl::SECRETKEYBYTES * 2)

      NaCl.crypto_sign_seed_keypair(pk, sk, seed) || raise(CryptoError, "Failed to generate a key pair")

      @seed, @signing_key = seed, sk
      @verify_key = VerifyKey.new(pk)
    end

    def sign(message)
      buffer = Util.prepend_zeros(NaCl::SIGNATUREBYTES, message)
      buffer_len = Util.zeros(FFI::Type::LONG_LONG.size)

      NaCl.crypto_sign(buffer, buffer_len, message, message.bytesize, @signing_key)

      buffer[0, NaCl::SIGNATUREBYTES]
    end

    def to_bytes
      @seed.dup
    end

    def inspect
      "#<#{self.class}:#{@seed.unpack("H*").first}>"
    end
  end
end
