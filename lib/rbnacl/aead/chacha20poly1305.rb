# encoding: binary
module RbNaCl
  module AEAD
    class Chacha20Poly1305
      extend Sodium

      sodium_type :aead
      sodium_primitive :chacha20poly1305
      sodium_constant :KEYBYTES
      sodium_constant :NPUBBYTES
      sodium_constant :ABYTES

      sodium_function :aead_chacha20poly1305_encrypt,
                      :crypto_aead_chacha20poly1305_encrypt,
                      [:pointer, :pointer, :pointer, :ulong_long, :pointer, :ulong_long, :pointer, :pointer, :pointer]

      sodium_function :aead_chacha20poly1305_decrypt,
                      :crypto_aead_chacha20poly1305_decrypt,
                      [:pointer, :pointer, :pointer, :pointer, :ulong_long, :pointer, :ulong_long, :pointer, :pointer]


      # Create a new AEAD using the original chacha20poly1305 construction
      #
      # Sets up the AEAD with a secret key for encrypting and decrypting messages.
      #
      # @param key [String] The key to encrypt and decrypt with
      #
      # @raise [RbNaCl::LengthError] on invalid keys
      #
      # @return [RbNaCl::AEAD::Chacha20Poly1305IETF] The new AEAD Box, ready to use
      def initialize(key)
        @key = Util.check_string(key, KEYBYTES, "Secret key")
      end


      # Encrypts and authenticates a message with additional data
      #
      # @param nonce [String] An 8-byte string containing the nonce.
      # @param message [String] The message to be encrypted.
      # @param additional_data [String] The additional authenticated data
      #
      # @raise [RbNaCl::LengthError] If the nonce is not valid
      # @raise [RbNaCl::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The decrypted message (BINARY encoded)
      def encrypt(nonce, message, additional_data)
        Util.check_length(nonce, NPUBBYTES, "Nonce")

        ciphertext_len = Util.zeros(1)
        ciphertext = Util.zeros(message.bytesize + ABYTES)

        success = self.class.aead_chacha20poly1305_encrypt(ciphertext, ciphertext_len,
                                                           message, message.bytesize,
                                                           additional_data, additional_data.bytesize,
                                                           nil, nonce, @key)
        raise CryptoError, "Encryption failed" unless success
        ciphertext
      end

      # Decrypts and verifies an encrypted message with additional data
      #
      # @param nonce [String] An 8-byte string containing the nonce.
      # @param ciphertext [String] The message to be decrypted.
      # @param additional_data [String] The additional authenticated data
      #
      # @raise [RbNaCl::LengthError] If the nonce is not valid
      # @raise [RbNaCl::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The decrypted message (BINARY encoded)
      def decrypt(nonce, ciphertext, additional_data)
        Util.check_length(nonce, NPUBBYTES, "Nonce")

        message_len = Util.zeros(1)
        message = Util.zeros(ciphertext.bytesize - ABYTES)

        success = self.class.aead_chacha20poly1305_decrypt(message, message_len, nil,
                                                           ciphertext, ciphertext.bytesize,
                                                           additional_data, additional_data.bytesize,
                                                           nonce, @key)
        raise CryptoError, "Decryption failed. Ciphertext failed verification." unless success
        message
      end

      # The nonce bytes for the AEAD class
      #
      # @return [Integer] The number of bytes in a valid nonce
      def self.nonce_bytes
        NPUBBYTES
      end

      # The nonce bytes for the AEAD instance
      #
      # @return [Integer] The number of bytes in a valid nonce
      def nonce_bytes
        NPUBBYTES
      end

      # The key bytes for the AEAD class
      #
      # @return [Integer] The number of bytes in a valid key
      def self.key_bytes
        KEYBYTES
      end
    end
  end
end
