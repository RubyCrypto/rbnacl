# encoding: binary
module Crypto
  # Secret Key Authenticators
  #
  # These provide a means of verifying the integrity of a message, but only
  # with the knowledge of a shared key.  This can be a preshared key, or one
  # that is derived through some cryptographic protocol.
  class Auth
    # Number of bytes in a valid key
    KEYBYTES = 0

    # Number of bytes in a valid authenticator
    BYTES = 0

    attr_reader :key
    private :key

    # A new authenticator, ready for auth and verification
    #
    # @param [#to_str] key the key used for authenticators, 32 bytes.
    def initialize(key)
      @key = Util.check_string(key, key_bytes, "#{self.class} key")
    end

    # Compute authenticator for message
    #
    # @param [#to_str] key the key used for the authenticator
    # @param [#to_str] message message to construct an authenticator for
    #
    # @return [String] The authenticator, as raw bytes
    def self.auth(key, message)
      new(key).auth(message)
    end

    # Verifies the given authenticator with the message.
    #
    # @param [#to_str] key the key used for the authenticator
    # @param [#to_str] message the message to be authenticated
    # @param [#to_str] authenticator to be checked
    #
    # @return [Boolean] Was it valid?
    def self.verify(key, message, authenticator)
      new(key).verify(message, authenticator)
    end

    # Compute authenticator for message
    #
    # @param [#to_str] message the message to authenticate
    #
    # @return [String] The authenticator in the requested encoding (default raw)
    def auth(message)
      authenticator = Util.zeros(tag_bytes)
      message = message.to_str
      compute_authenticator(message, authenticator)
      authenticator
    end

    # Verifies the given authenticator with the message.
    #
    # @param [#to_str] authenticator to be checked
    # @param [#to_str] message the message to be authenticated
    #
    # @return [Boolean] Was it valid?
    def verify(message, authenticator)
      auth = authenticator.to_s
      return false unless auth.bytesize == tag_bytes
      verify_message(message, auth)
    end

    # The crypto primitive for this authenticator instance
    #
    # @return [Symbol] The primitive used
    def primitive
      self.class.primitive
    end

    # The number of key bytes for this Auth class
    #
    # @return [Integer] number of key bytes
    def self.key_bytes; self::KEYBYTES; end

    # The number of key bytes for this Auth instance
    #
    # @return [Integer] number of key bytes
    def key_bytes; self.class.key_bytes; end

    # The number bytes in the tag or authenticator from this Auth class
    #
    # @return [Integer] number of tag bytes
    def self.tag_bytes; self::BYTES; end

    # The number of bytes in the tag or authenticator for this Auth instance
    #
    # @return [Integer] number of tag bytes
    def tag_bytes; self.class.tag_bytes; end

    private
    def compute_authenticator(message, authenticator); raise NotImplementedError; end
    def verify_message(message, authenticator);        raise NotImplementedError; end
  end
end
