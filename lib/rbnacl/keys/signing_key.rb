module Crypto
  # Private key for producing digital signatures using the Ed25519 algorithm.
  # Ed25519 provides a 128-bit security level, that is to say, all known attacks
  # take at least 2^128 operations, providing the same security level as
  # AES-128, NIST P-256, and RSA-3072.
  #
  # Signing keys are produced from a 32-byte (256-bit) random seed value.
  # This value can be passed into the SigningKey constructoras a String
  # whose bytesize is 32.
  #
  # The public VerifyKey can be computed from the private 32-byte seed value
  # as well, eliminating the need to store a "keypair".
  #
  # SigningKey produces 64-byte (512-bit) signatures. The signatures are
  # deterministic: signing the same message will always produce the same
  # signature. This prevents "entropy failure" seen in other signature
  # algorithms like DSA and ECDSA, where poor random number generators can
  # leak enough information to recover the private key.
  class SigningKey
    attr_reader :verify_key

    # Generate a random SigningKey
    #
    # @return [Crypto::SigningKey] Freshly-generated random SigningKey
    def self.generate
      new Crypto::Random.random_bytes(NaCl::SECRETKEYBYTES)
    end

    # Create a SigningKey from a seed value
    #
    # @param seed [String] Random 32-byte value (i.e. private key)
    #
    # @return [Crypto::SigningKey] Key which can sign messages
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

    # Sign a message using this key
    #
    # @param message [String] Message to be signed by this key
    #
    # @return [String] Signature as bytes 
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
