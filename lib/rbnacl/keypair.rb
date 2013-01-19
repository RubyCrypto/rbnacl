#!/usr/bin/env ruby
module Crypto
  # KeyPair is responsible for generating and storing keys
  #
  # This class mostly exists for the generator method.  The key-using functions
  # all accept strings (which is all the public and private keys are).  But its
  # here, if you want to pass things around.  And it does mean that you don't
  # have to remember which order the keys are returned from the generate method.
  class KeyPair
    attr_reader :pk, :sk

    # Stores a public key and an optional secret key
    #
    # @param pk [String] The public key
    # @param sk [String] The secret key
    #
    # @return [Crypto::KeyPair] the new keypair
    def initialize(pk, sk = nil)
      @pk = pk
      @sk = sk
    end

    # Generates a new keypair
    #
    # @raise [Crypto::CryptoError] if key generation fails, due to insufficient randomness.
    #
    # @return [Crypto::KeyPair] A new keypair, ready for use.
    def self.generate
    end

    # Is the given key possibly a valid public key?
    #
    # This checks the length, and does no other validation. But a public key
    # is just a 32-byte random number, unless you have a secret key to check
    # whether it was derived from that.
    #
    # @return [Boolean] Well, is it?
    def self.valid_pk?
    end

    # Does this keypair have a valid public key?
    #
    # This checks the length, and does no other validation. But a public key
    # is just a 32-byte random number, unless you have a secret key to check
    # whether it was derived from that.
    #
    # @return [Boolean] Well, does it?
    def pk?
      self.class.valid_pk?(pk)
    end
    alias_method :public?, :pk?

    # Is the given key possibly a valid secret key?
    #
    # This checks the length, and does no other validation. But a secret key
    # is just a 32-byte random number.
    #
    # @return [Boolean] Well, is it?
    def self.valid_sk?
    end

    # Does this keypair have a valid secret key?
    #
    # This checks the length, and does no other validation. But a secret key
    # is just a 32-byte random number.
    #
    # @return [Boolean] Well, does it?
    def sk?
      self.class.valid_sk?(sk)
    end
    alias_method :secret?, :sk?
  end
end
