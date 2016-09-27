# encoding: binary
module RbNaCl
  module AEAD
    class Chacha20Poly1305IETF
      extend Sodium

      sodium_type :aead
      sodium_primitive :chacha20poly1305_ietf
      sodium_constant :KEYBYTES
      sodium_constant :NPUBBYTES
      sodium_constant :ABYTES

      sodium_function :aead_chacha20poly1305_ietf_encrypt,
                      :crypto_aead_chacha20poly1305_ietf_encrypt,
                      [:pointer, :pointer, :pointer, :ulong_long, :pointer, :ulong_long, :pointer, :pointer, :pointer]

      sodium_function :aead_chacha20poly1305_ietf_decrypt,
                      :crypto_aead_chacha20poly1305_ietf_decrypt,
                      [:pointer, :pointer, :pointer, :pointer, :ulong_long, :pointer, :ulong_long, :pointer, :pointer]


      # Encrypts and authenticates a message with additional data
      def encrypt(key, nonce, message, additional_data)
        ciphertext_len = Util.zeros(1)
        ciphertext = Util.zeros(message.bytesize + ABYTES)

        Util.check_length(nonce, NPUBBYTES, "Nonce")
        key = Util.check_string(key, KEYBYTES, "Secret key")

        success = self.class.aead_chacha20poly1305_ietf_encrypt(ciphertext, ciphertext_len,
                                                           message, message.bytesize,
                                                           additional_data, additional_data.bytesize,
                                                           nil, nonce, key)
        raise CryptoError, "Encryption failed" unless success
        ciphertext
      end

      # Decrypts and verifies an encrypted message with additional data
      def decrypt(key, nonce, ciphertext, additional_data)
        message_len = Util.zeros(1)
        message = Util.zeros(ciphertext.bytesize - ABYTES)

        Util.check_length(nonce, NPUBBYTES, "Nonce")
        key = Util.check_string(key, KEYBYTES, "Secret key")

        success = self.class.aead_chacha20poly1305_ietf_decrypt(message, message_len, nil,
                                                           ciphertext, ciphertext.bytesize,
                                                           additional_data, additional_data.bytesize,
                                                           nonce, key)
        raise CryptoError, "Decryption failed. Ciphertext failed verification." unless success
        message
      end
    end
  end
end
