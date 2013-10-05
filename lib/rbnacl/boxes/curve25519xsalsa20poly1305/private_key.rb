# encoding: binary

module RbNaCl
  # RbNaCl::Box private key. Keep it safe
  #
  # This class generates and stores NaCL private keys, as well as providing a
  # reference to the public key associated with this private key, if that's
  # provided.
  #
  # Note that the documentation for NaCl refers to this as a secret key, but in
  # this library its a private key, to avoid confusing the issue with the
  # SecretBox, which does symmetric encryption.
  class Boxes::Curve25519XSalsa20Poly1305::PrivateKey

    include KeyComparator
    include Serializable
      
    extend Sodium

    sodium_type      :box
    sodium_primitive :curve25519xsalsa20poly1305

    sodium_function :box_curve25519xsalsa20poly1305_keypair,
                    :crypto_box_curve25519xsalsa20poly1305_keypair,
                    [:pointer, :pointer]

    # The size of the key, in bytes
    BYTES = Boxes::Curve25519XSalsa20Poly1305::PRIVATEKEYBYTES

    # Initializes a new PrivateKey for key operations.
    #
    # Takes the (optionally encoded) private key bytes.  This class can then be
    # used for various key operations, including deriving the corresponding
    # PublicKey
    #
    # @param private_key [String] The private key
    # @param key_encoding [Symbol] The encoding of the key
    #
    # @raise [TypeError] If the key is nil
    # @raise [RbNaCl::LengthError] If the key is not valid after decoding.
    #
    # @return A new PrivateKey
    def initialize(private_key)
      @private_key = Util.check_string(private_key, BYTES, "Private key")
    end

    # Generates a new keypair
    #
    # @raise [RbNaCl::CryptoError] if key generation fails, due to insufficient randomness.
    #
    # @return [RbNaCl::PrivateKey] A new private key, with the associated public key also set.
    def self.generate
      pk = Util.zeros(Boxes::Curve25519XSalsa20Poly1305::PUBLICKEYBYTES)
      sk = Util.zeros(Boxes::Curve25519XSalsa20Poly1305::PRIVATEKEYBYTES)
      self.box_curve25519xsalsa20poly1305_keypair(pk, sk) || raise(CryptoError, "Failed to generate a key pair")
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
      @public_key ||= PublicKey.new GroupElements::Curve25519.base.mult(to_bytes)
    end
    
    # The crypto primitive this PrivateKey is to be used for.
    #
    # @return [Symbol] The primitive
    def primitive
      self.class.primitive
    end
  end
end
