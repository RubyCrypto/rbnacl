# encoding: binary
module RbNaCl

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
    # @param [#to_str] authenticator to be checked
    # @param [#to_str] message the message to be authenticated
    #
    # @raise [BadAuthenticatorError] if the tag isn't valid
    # @raise [LengthError]  if the tag is of the wrong length
    #
    # @return [Boolean] Was it valid?
    def self.verify(key, authenticator, message)
      new(key).verify(authenticator, message)
    end

    # Compute authenticator for message
    #
    # @param [#to_str] message the message to authenticate
    #
    # @return [String] the authenticator as raw bytes
    def auth(message)
      authenticator = Util.zeros(tag_bytes)
      message = message.to_str
      compute_authenticator(authenticator, message)
      authenticator
    end

    # Verifies the given authenticator with the message.
    #
    # @param [#to_str] authenticator to be checked
    # @param [#to_str] message the message to be authenticated
    #
    # @raise [BadAuthenticatorError] if the tag isn't valid
    # @raise [LengthError]  if the tag is of the wrong length
    #
    # @return [Boolean] Was it valid?
    def verify(authenticator, message)
      auth = authenticator.to_s
      Util.check_length(auth, tag_bytes, "Provided authenticator")
      verify_message(auth, message) || raise(BadAuthenticatorError, "Invalid authenticator provided, message is corrupt")
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
    def compute_authenticator(authenticator, message); raise NotImplementedError; end
    def verify_message(authenticator, message);        raise NotImplementedError; end
  end
end
