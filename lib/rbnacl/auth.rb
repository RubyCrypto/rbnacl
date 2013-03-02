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
    # @param [#to_sym] encoding decode key from this format (default raw)
    def initialize(key, encoding = :raw)
      @key = Encoder[encoding].decode(key)
      Util.check_length(@key, self.class::KEYBYTES, "#{self.class} key")
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
    # @param [#to_sym] authenticator_encoding format of the authenticator (default raw)
    #
    # @return [String] The authenticator in the requested encoding (default raw)
    def auth(message, authenticator_encoding = :raw)
      authenticator = Util.zeros(self.class::BYTES)
      message = message.to_str
      compute_authenticator(message, authenticator)
      Encoder[authenticator_encoding].encode(authenticator)
    end

    # Verifies the given authenticator with the message.
    #
    # @param [#to_str] authenticator to be checked
    # @param [#to_str] message the message to be authenticated
    # @param [#to_sym] authenticator_encoding format of the authenticator (default raw)
    #
    # @return [Boolean] Was it valid?
    def verify(message, authenticator, authenticator_encoding = :raw)
      auth = Encoder[authenticator_encoding].decode(authenticator)
      return false unless auth.bytesize == self.class::BYTES
      verify_message(message, auth)
    end

    private
    def compute_authenticator(message, authenticator); raise NotImplementedError; end
    def verify_message(message, authenticator);        raise NotImplementedError; end
  end
end
