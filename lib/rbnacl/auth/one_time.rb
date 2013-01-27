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
      def initialize(key)
        raise ArgumentError, "Key must not be nil" if key.nil?
        @key = key.to_str
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
      #
      # @return [String] The authenticator, as raw bytes
      def auth(message)
        authenticator = Util.zeros(BYTES)
        message = message.to_str
        NaCl.crypto_auth_onetime(authenticator, message, message.bytesize, @key)
        authenticator
      end

      # Compute authenticator for message and hex encode it
      #
      # @param [#to_str] message the message to authenticate
      #
      # @return [String] The authenticator, hex-encoded
      def hexauth(message)
        Util.hexencode(auth(message))
      end

      # Verifies the given authenticator with the message.
      #
      # @param [#to_str] authenticator to be checked
      # @param [#to_str] message the message to be authenticated
      #
      # @return [Boolean] Was it valid?
      def verify(authenticator, message)
        auth = authenticator.to_str
        return false unless auth.bytesize == BYTES
        NaCl.crypto_auth_onetime_verify(authenticator, message, message.bytesize, @key)
      end

      # Verifies the given hex-authenticator with the message.
      #
      # @param [#to_str] authenticator to be checked, hex encoded
      # @param [#to_str] message the message to be authenticated
      #
      # @return [Boolean] Was it valid?
      def hexverify(authenticator, message)
        verify(Util.hexdecode(authenticator), message)
      end

      private
      def valid?
        @key.bytesize == KEYBYTES
      end
    end
  end
end
