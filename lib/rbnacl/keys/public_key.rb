module Crypto
  # Crypto::Box public key. Send to your friends.
  #
  # This class stores the NaCL public key, and provides some convience
  # functions for working with it.
  class PublicKey
    # The size of the key, in bytes
    SIZE = Crypto::NaCl::PUBLICKEYBYTES

    def initialize(public_key)
      @public_key = public_key
      raise ArgumentError, "PublicKey must be #{SIZE} bytes long" unless valid?
    end

    def inspect
      "#<Crypto::PublicKey:#{to_hex}>"
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @public_key
    end
    alias_method :to_s, :to_bytes

    # hex encoding of the key
    #
    # @return [String] the key, hex encoded.
    def to_hex
      to_bytes.unpack("H*").first
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
