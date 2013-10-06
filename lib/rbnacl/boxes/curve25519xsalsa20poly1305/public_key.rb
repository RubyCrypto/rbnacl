# encoding: binary

module RbNaCl
  # RbNaCl::Box public key. Send it (securely!) to your friends.
  #
  # This class stores the NaCL public key, and provides some convenience
  # functions for working with it.
  class Boxes::Curve25519XSalsa20Poly1305::PublicKey

    include KeyComparator
    include Serializable

    # The size of the key, in bytes
    BYTES = Boxes::Curve25519XSalsa20Poly1305::PUBLICKEYBYTES

    # Initializes a new PublicKey for key operations.
    #
    # Takes the (optionally encoded) public key bytes.  This can be shared with
    # many people and used to establish key pairs with their private key, for
    # the exchanging of messages using a RbNaCl::Box
    #
    # @param public_key [String] The public key
    #
    # @raise [RbNaCl::LengthError] If the key is not valid after decoding.
    #
    # @return A new PublicKey
    def initialize(public_key)
      @public_key = Util.check_string(public_key, BYTES, "Public key")
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @public_key
    end

    # The crypto primitive the PublicKey class is to be used for
    #
    # @return [Symbol] The primitive
    def self.primitive
      :curve25519xsalsa20poly1305
    end

    # The crypto primitive this PublicKey is to be used for.
    #
    # @return [Symbol] The primitive
    def primitive
      self.class.primitive
    end
  end

end
