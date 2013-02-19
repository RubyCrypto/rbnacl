module Crypto
  # Crypto::Box public key. Send to your friends.
  #
  # This class stores the NaCL public key, and provides some convience
  # functions for working with it.
  class PublicKey
    include KeyComparator
    include Serializable

    # The size of the key, in bytes
    BYTES = Crypto::NaCl::PUBLICKEYBYTES

    # Initializes a new PublicKey for key operations.
    #
    # Takes the (optionally encoded) public key bytes.  This can be shared with
    # many people and used to establish key pairs with their private key, for
    # the exchanging of messages using a Crypto::Box
    #
    # @param public_key [String] The public key
    # @param key_encoding [Symbol] The encoding of the key
    #
    # @raise [Crypto::LengthError] If the key is not valid after decoding.
    #
    # @return A new PublicKey
    def initialize(public_key, key_encoding = :raw)
      @public_key = Crypto::Encoder[key_encoding].decode(public_key)
      Util.check_length(@public_key, BYTES, "Public key")
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @public_key
    end
  end
end
