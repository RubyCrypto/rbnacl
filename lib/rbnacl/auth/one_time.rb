module Crypto
  module Auth
    # Computes an authenticator using poly1305
    #
    # The authenticator can be used at a later data to verify the provenence of
    # the data by recomputing the tag over the data and then comparing it to
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

      # Compute authenticator for data
      #
      # @param [#to_str] key the key used for the authenticator
      # @param [#to_str] data data to construct an authenticator for
      #
      # @return [String] The authenticator, as raw bytes
      def self.auth(key, data)
        new(key).auth(data)
      end

      # Verifies the given authenticator with the data.
      #
      # @param [#to_str] key the key used for the authenticator
      # @param [#to_str] authenticator to be checked
      # @param [#to_str] data the data to be authenticated
      #
      # @return [Boolean] Was it valid?
      def self.verify(key, authenticator, data)
        new(key).verify(authenticator, data)
      end

      # Compute authenticator for data
      #
      # @param [#to_str] data the data to authenticate
      #
      # @return [String] The authenticator, as raw bytes
      def auth(data)
        authenticator = Util.zeros(BYTES)
        data = data.to_str
        NaCl.crypto_auth_onetime(authenticator, data, data.bytesize, @key)
        authenticator
      end

      # Compute authenticator for data and hex encode it
      #
      # @param [#to_str] data the data to authenticate
      #
      # @return [String] The authenticator, hex-encoded
      def hexauth(data)
        Util.hexencode(auth(data))
      end

      # Verifies the given authenticator with the data.
      #
      # @param [#to_str] authenticator to be checked
      # @param [#to_str] data the data to be authenticated
      #
      # @return [Boolean] Was it valid?
      def verify(authenticator, data)
        auth = authenticator.to_str
        return false unless auth.bytesize == BYTES
        NaCl.crypto_auth_onetime_verify(authenticator, data, data.bytesize, @key)
      end

      # Verifies the given hex-authenticator with the data.
      #
      # @param [#to_str] authenticator to be checked, hex encoded
      # @param [#to_str] data the data to be authenticated
      #
      # @return [Boolean] Was it valid?
      def hexverify(authenticator, data)
        verify(Util.hexdecode(authenticator), data)
      end

      private
      def valid?
        @key.bytesize == KEYBYTES
      end
    end
  end
end
