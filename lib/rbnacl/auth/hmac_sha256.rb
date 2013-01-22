module Crypto
  module Auth
    # Computes an authenticator as HMAC-SHA-256
    #
    # The authenticator can be used at a later data to verify the provenence of
    # the data by recomputing the HMAC over the data and then comparing it to
    # the provided authenticator.  The class provides methods for generating
    # signatures and also has a constant-time implementation for checking them.
    #
    # This is a secret key authenticator, i.e. anyone who can verify signatures
    # can also create them.
    class HmacSha256
      # Number of bytes in a valid key
      KEYBYTES = NaCl::HMACSHA256_KEYBYTES

      # Number of bytes in a valid authenticator
      BYTES = NaCl::HMACSHA256_BYTES

      # A new authenticator, ready for auth and verification
      #
      # @param [#to_str] key the key used for authenticators, 32 bytes or less.
      def initialize(key)
        raise ArgumentError, "Key must not be nil" if key.nil?
        @key = pad_key(key.to_str)
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
        NaCl.crypto_auth_hmacsha256(authenticator, data, data.bytesize, @key)
        authenticator
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
        NaCl.crypto_auth_hmacsha256_verify(authenticator, data, data.bytesize, @key)
      end

      private
      def pad_key(key)
        if key.bytesize < KEYBYTES
          key = key + Util.zeros(KEYBYTES - key.bytesize)
        end
        key
      end

      def valid?
        @key.bytesize == KEYBYTES
      end
    end
  end
end
