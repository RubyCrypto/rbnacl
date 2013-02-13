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

    # The size of the key, in bytes
    SIZE = Crypto::NaCl::SECRETKEYBYTES

    # Initializes a new PrivateKey for key operations.
    #
    # Takes the (optionally encoded) private key bytes.  This class can then be
    # used for various key operations, including deriving the corresponding
    # PublicKey
    #
    # @param private_key [String] The private key
    # @param key_encoding [Symbol] The encoding of the key
    #
    # @raise [ArgumentError] If the key is not valid after decoding.
    #
    # @return A new PrivateKey
    def initialize(private_key, key_encoding = :raw)
      @private_key = Crypto::Encoder[key_encoding].decode(private_key)

      raise ArgumentError, "PrivateKey must be #{SIZE} bytes long" unless valid?
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

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<Crypto::PrivateKey:#{to_s(:hex)}>" # a bit dangerous, but okay.
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @private_key
    end
    
    # Return a string representation of this key, possibly encoded into a
    # given serialization format.
    #
    # @param encoding [String] string encoding format in which to encode the key
    #
    # @return [String] key encoded in the specified format
    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end

    # the public key associated with this private key
    #
    # @return [PublicKey] the key
    def public_key
      @public_key ||= PublicKey.new(Point.base.mult(to_bytes))
    end

    # Is the given key possibly a valid private key?
    #
    # This checks the length, and does no other validation. But a private key
    # is just a 32-byte random number.
    #
    # @param [String] key The string to test
    #
    # @return [Boolean] Well, is it?
    def self.valid?(key)
      return false unless key.respond_to?(:bytesize)
      key.bytesize == SIZE
    end

    # Is the key possibly a valid private key?
    #
    # This checks the length, and does no other validation. But a private key
    # is just a 32-byte random number.
    #
    # @return [Boolean] Well, is it?
    def valid?
      self.class.valid?(@private_key)
    end
  end
end
