module Crypto
  module Auth
    # Computes an authenticator as HMAC-SHA-512 truncated to 256-bits
    #
    # The authenticator can be used at a later time to verify the provenence of
    # the message by recomputing the HMAC over the message and then comparing it to
    # the provided authenticator.  The class provides methods for generating
    # signatures and also has a constant-time implementation for checking them.
    #
    # This is a secret key authenticator, i.e. anyone who can verify signatures
    # can also create them.
    #
    # @see http://nacl.cr.yp.to/auth.html
    class HmacSha512256
      # Number of bytes in a valid key
      KEYBYTES = NaCl::HMACSHA512256_KEYBYTES

      # Number of bytes in a valid authenticator
      BYTES = NaCl::HMACSHA512256_BYTES

      # A new authenticator, ready for auth and verification
      #
      # @param [#to_str] key the key used for authenticators, 32 bytes or less.
      # @param [#to_sym] encoding decode key from this format (default raw)
      def initialize(key, encoding = :raw)
        raise ArgumentError, "Key must not be nil" if key.nil?
        @key = pad_key Encoder[encoding].decode(key)
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
        NaCl.crypto_auth_hmacsha512256(authenticator, message, message.bytesize, @key)
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
        NaCl.crypto_auth_hmacsha512256_verify(auth, message, message.bytesize, @key)
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
