module Crypto
  # Crypto::Box public key. Send to your friends.
  #
  # This class stores the NaCL public key, and provides some convience
  # functions for working with it.
  class PublicKey
    include KeyComparator

    # The size of the key, in bytes
    SIZE = Crypto::NaCl::PUBLICKEYBYTES

    # Initializes a new PublicKey for key operations.
    #
    # Takes the (optionally encoded) public key bytes.  This can be shared with
    # many people and used to establish key pairs with their private key, for
    # the exchanging of messages using a Crypto::Box
    #
    # @param public_key [String] The public key
    # @param key_encoding [Symbol] The encoding of the key
    #
    # @raise [ArgumentError] If the key is not valid after decoding.
    #
    # @return A new PublicKey
    def initialize(public_key, key_encoding = :raw)
      @public_key = Crypto::Encoder[key_encoding].decode(public_key)

      raise ArgumentError, "PublicKey must be #{SIZE} bytes long" unless valid?
    end

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<Crypto::PublicKey:#{to_s(:hex)}>"
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @public_key
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

    # Is the given key possibly a valid public key?
    #
    # This checks the length, and does no other validation. But a public key
    # is just a 32-byte random number without a private key to check against
    #
    # @param [String] key The string to test
    #
    # @return [Boolean] Well, is it?
    def self.valid?(key)
      return false unless key.respond_to?(:bytesize)
      key.bytesize == SIZE
    end

    # Is the given key possibly a valid public key?
    #
    # This checks the length, and does no other validation. But a public key
    # is just a 32-byte random number without a private key to check against
    #
    # @param [String] The string to test
    #
    # @return [Boolean] Well, is it?
    def valid?
      self.class.valid?(@public_key)
    end
  end
end
