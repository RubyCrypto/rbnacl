module Crypto
  # Crypto::Box private key. Keep it safe
  #
  # This class generates and stores NaCL private keys, as well as providing a
  # reference to the public key associated with this private key, if that's
  # provided.
  #
  # Note that the documentation for NaCl refers to this as a secret key, but in
  # this library its a private key, to avoid confusing the issue with the
  # SecretBox, which does symmetric encryption.
  class PrivateKey
    include KeyComparator
    include Serializable

    # The size of the key, in bytes
    BYTES = Crypto::NaCl::SECRETKEYBYTES

    # Initializes a new PrivateKey for key operations.
    #
    # Takes the (optionally encoded) private key bytes.  This class can then be
    # used for various key operations, including deriving the corresponding
    # PublicKey
    #
    # @param private_key [String] The private key
    # @param key_encoding [Symbol] The encoding of the key
    #
    # @raise [Crypto::LengthError] If the key is not valid after decoding.
    #
    # @return A new PrivateKey
    def initialize(private_key, key_encoding = :raw)
      @private_key = Crypto::Encoder[key_encoding].decode(private_key)
      Util.check_length(@private_key, BYTES, "Private key")
    end

    # Generates a new keypair
    #
    # @raise [Crypto::CryptoError] if key generation fails, due to insufficient randomness.
    #
    # @return [Crypto::PrivateKey] A new private key, with the associated public key also set.
    def self.generate
      pk = Util.zeros(NaCl::PUBLICKEYBYTES)
      sk = Util.zeros(NaCl::SECRETKEYBYTES)
      NaCl.crypto_box_keypair(pk, sk) || raise(CryptoError, "Failed to generate a key pair")
      new(sk)
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @private_key
    end

    # the public key associated with this private key
    #
    # @return [PublicKey] the key
    def public_key
      @public_key ||= PublicKey.new(Point.base.mult(to_bytes))
    end
  end
end
