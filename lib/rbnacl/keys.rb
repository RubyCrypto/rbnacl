#!/usr/bin/env ruby
module Crypto
  # The NaCl secret key.  Keep it safe
  #
  # This class generates and stores NaCL secret keys, as well as providing a
  # reference to the public key associated with this private key, if that's
  # provided.
  class SecretKey
    def initialize(secret_key, public_key = nil)
      @secret_key = secret_key

      raise ArgumentError, "SecretKey must be #{Crypto::NaCl::PUBLICKEYBYTES} bytes long" unless valid?

      @public_key = PublicKey.new(public_key) if public_key
    end

    # Generates a new keypair
    #
    # @raise [Crypto::CryptoError] if key generation fails, due to insufficient randomness.
    #
    # @return [Crypto::SecretKey] A new secret key, with the associated public key also set.
    def self.generate
      pk = Util.zeros(NaCl::PUBLICKEYBYTES)
      sk = Util.zeros(NaCl::SECRETKEYBYTES)
      ret = NaCl.crypto_box_curve25519xsalsa20poly1305_ref_keypair(pk, sk)
      raise CryptoError, "Failed to generate a key pair" if ret != 0
      new(sk, pk)
    end

    def inspect
      "#<Crypto::SecretKey:#{to_hex}>" # a bit dangerous, but okay.
    end

    # The raw bytes of the key
    #
    # @return [String] the raw bytes.
    def to_bytes
      @secret_key
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

    # Is the given key possibly a valid secret key?
    #
    # This checks the length, and does no other validation. But a secret key
    # is just a 32-byte random number.
    #
    # @param [String] key The string to test
    #
    # @return [Boolean] Well, is it?
    def self.valid?(key)
      return false unless key.respond_to?(:bytesize)
      key.bytesize == NaCl::SECRETKEYBYTES
    end

    # Is the key possibly a valid secret key?
    #
    # This checks the length, and does no other validation. But a secret key
    # is just a 32-byte random number.
    #
    # @return [Boolean] Well, is it?
    def valid?
      self.class.valid?(@secret_key)
    end
  end

  # The NaCl public key.  Send to your friends.
  #
  # This class stores the NaCL public key, and provides some convience
  # functions for working with it.
  class PublicKey
    def initialize(public_key)
      @public_key = public_key
      raise ArgumentError, "PublicKey must be #{Crypto::NaCl::PUBLICKEYBYTES} bytes long" unless valid?
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
    # is just a 32-byte random number without a secret key to check against
    #
    # @param [String] key The string to test
    #
    # @return [Boolean] Well, is it?
    def self.valid?(key)
      return false unless key.respond_to?(:bytesize)
      key.bytesize == NaCl::PUBLICKEYBYTES
    end

    # Is the given key possibly a valid public key?
    #
    # This checks the length, and does no other validation. But a public key
    # is just a 32-byte random number without a secret key to check against
    #
    # @param [String] The string to test
    #
    # @return [Boolean] Well, is it?
    def valid?
      self.class.valid?(@public_key)
    end
  end
end
