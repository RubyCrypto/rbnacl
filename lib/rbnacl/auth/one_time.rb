module Crypto
  module Auth
    # Computes an authenticator using poly1305
    #
    # The authenticator can be used at a later time to verify the provenence of
    # the message by recomputing the tag over the message and then comparing it to
    # the provided authenticator.  The class provides methods for generating
    # signatures and also has a constant-time implementation for checking them.
    #
    # As the name suggests, this is a **ONE TIME** authenticator.  Computing an
    # authenticator for two messages using the same key probably gives an
    # attacker enough information to forge further authenticators for the same
    # key.
    #
    # This is a secret key authenticator, i.e. anyone who can verify signatures
    # can also create them.
    #
    # @see http://nacl.cr.yp.to/onetimeauth.html
    class OneTime
      # Number of bytes in a valid key
      KEYBYTES = NaCl::ONETIME_KEYBYTES

      # Number of bytes in a valid authenticator
      BYTES = NaCl::ONETIME_BYTES

      # A new authenticator, ready for auth and verification
      #
      # @param [#to_str] key the key used for authenticators, 32 bytes.
      # @param [#to_sym] encoding decode key from this format (default raw)
      def initialize(key, encoding = :raw)
        raise ArgumentError, "Key must not be nil" if key.nil?
        @key = Encoder[encoding].decode(key)
        raise ArgumentError, "Key must be #{KEYBYTES} bytes" unless valid?
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
      # @return [Boolean] Was it valid?
      def self.verify(key, authenticator, message)
        new(key).verify(authenticator, message)
      end

      # Compute authenticator for message
      #
      # @param [#to_str] message the message to authenticate
      # @param [#to_sym] authenticator_encoding format of the authenticator (default raw)
      #
      # @return [String] The authenticator in the requested encoding (default raw)
      def auth(message, authenticator_encoding = :raw)
        authenticator = Util.zeros(BYTES)
        message = message.to_str
        NaCl.crypto_auth_onetime(authenticator, message, message.bytesize, @key)
        Encoder[authenticator_encoding].encode(authenticator)
      end

      # Verifies the given authenticator with the message.
      #
      # @param [#to_str] authenticator to be checked
      # @param [#to_str] message the message to be authenticated
      # @param [#to_sym] authenticator_encoding format of the authenticator (default raw)
      #
      # @return [Boolean] Was it valid?
      def verify(authenticator, message, authenticator_encoding = :raw)
        auth = Encoder[authenticator_encoding].decode(authenticator)
        return false unless auth.bytesize == BYTES
        NaCl.crypto_auth_onetime_verify(auth, message, message.bytesize, @key)
      end

      private
      def valid?
        @key.bytesize == KEYBYTES
      end
    end
  end
end
