# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module AEAD
    # Abstract base class for Authenticated Encryption with Additional Data
    #
    # This construction encrypts a message, and computes an authentication
    # tag for the encrypted message and some optional additional data
    #
    # RbNaCl provides wrappers for both ChaCha20-Poly1305 AEAD implementations
    # in libsodium: the original, and the IETF version.
    class Base
      # Number of bytes in a valid key
      KEYBYTES = 0

      # Number of bytes in a valid nonce
      NPUBBYTES = 0

      attr_reader :key
      private :key

      # Create a new AEAD using the IETF chacha20poly1305 construction
      #
      # Sets up AEAD with a secret key for encrypting and decrypting messages.
      #
      # @param key [String] The key to encrypt and decrypt with
      #
      # @raise [RbNaCl::LengthError] on invalid keys
      #
      # @return [RbNaCl::AEAD::Chacha20Poly1305IETF] The new AEAD construct, ready to use
      def initialize(key)
        @key = Util.check_string(key, key_bytes, "Secret key")
      end

      # Encrypts and authenticates a message with additional authenticated data
      #
      # @param nonce [String] An 8-byte string containing the nonce.
      # @param message [String] The message to be encrypted.
      # @param additional_data [String] The additional authenticated data
      #
      # @raise [RbNaCl::LengthError] If the nonce is not valid
      # @raise [RbNaCl::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The encrypted message with the authenticator tag appended
      def encrypt(nonce, message, additional_data)
        Util.check_length(nonce, nonce_bytes, "Nonce")

        ciphertext_len = Util.zeros(1)
        ciphertext = Util.zeros(data_len(message) + tag_bytes)

        success = do_encrypt(ciphertext, ciphertext_len, nonce, message, additional_data)
        raise CryptoError, "Encryption failed" unless success

        ciphertext
      end

      # Decrypts and verifies an encrypted message with additional authenticated data
      #
      # @param nonce [String] An 8-byte string containing the nonce.
      # @param ciphertext [String] The message to be decrypted.
      # @param additional_data [String] The additional authenticated data
      #
      # @raise [RbNaCl::LengthError] If the nonce is not valid
      # @raise [RbNaCl::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The decrypted message
      def decrypt(nonce, ciphertext, additional_data)
        Util.check_length(nonce, nonce_bytes, "Nonce")

        message_len = Util.zeros(1)
        message = Util.zeros(data_len(ciphertext) - tag_bytes)

        success = do_decrypt(message, message_len, nonce, ciphertext, additional_data)
        raise CryptoError, "Decryption failed. Ciphertext failed verification." unless success

        message
      end

      # The crypto primitive for this aead instance
      #
      # @return [Symbol] The primitive used
      def primitive
        self.class.primitive
      end

      # The nonce bytes for the AEAD class
      #
      # @return [Integer] The number of bytes in a valid nonce
      def self.nonce_bytes
        self::NPUBBYTES
      end

      # The nonce bytes for the AEAD instance
      #
      # @return [Integer] The number of bytes in a valid nonce
      def nonce_bytes
        self.class.nonce_bytes
      end

      # The key bytes for the AEAD class
      #
      # @return [Integer] The number of bytes in a valid key
      def self.key_bytes
        self::KEYBYTES
      end

      # The key bytes for the AEAD instance
      #
      # @return [Integer] The number of bytes in a valid key
      def key_bytes
        self.class.key_bytes
      end

      # The number bytes in the tag or authenticator from this AEAD class
      #
      # @return [Integer] number of tag bytes
      def self.tag_bytes
        self::ABYTES
      end

      # The number of bytes in the tag or authenticator for this AEAD instance
      #
      # @return [Integer] number of tag bytes
      def tag_bytes
        self.class.tag_bytes
      end

      private

      def data_len(data)
        return 0 if data.nil?

        data.bytesize
      end

      def do_encrypt(_ciphertext, _ciphertext_len, _nonce, _message, _additional_data)
        raise NotImplementedError
      end

      def do_decrypt(_message, _message_len, _nonce, _ciphertext, _additional_data)
        raise NotImplementedError
      end
    end
  end
end
