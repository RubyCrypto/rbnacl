#!/usr/bin/env ruby
module Crypto
  # The NaCl private key.  Keep it safe
  #
  # This class generates and stores NaCL private keys, as well as providing a
  # reference to the public key associated with this private key, if that's
  # provided.
  #
  # Note that the documentation for NaCl refers to this as a secret key, but in
  # this library its a private key, to avoid confusing the issue with the
  # SecretBox, which does symmetric encryption.
  class PrivateKey
    # The size of the key, in bytes
    SIZE = Crypto::NaCl::SECRETKEYBYTES

    def initialize(private_key, public_key = nil)
      @private_key = private_key

      raise ArgumentError, "PrivateKey must be #{SIZE} bytes long" unless valid?

      @public_key = PublicKey.new(public_key) if public_key
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
      new(sk, pk)
    end

    def inspect
      "#<Crypto::PrivateKey:#{to_hex}>" # a bit dangerous, but okay.
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @private_key
    end
    alias_method :to_s, :to_bytes

    # hex encoding of the key
    #
    # @return [String] the key, hex encoded.
    def to_hex
      to_bytes.unpack("H*").first
    end

    # the public key associated with this private key
    #
    # @return [PublicKey] the key
    def public_key
      @public_key
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

  # The NaCl public key.  Send to your friends.
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
