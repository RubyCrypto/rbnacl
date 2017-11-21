# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module AEAD
    # This class contains wrappers for the original libsodium implementation of
    # Authenticated Encryption with Additional Data using ChaCha20-Poly1305
    class ChaCha20Poly1305Legacy < RbNaCl::AEAD::Base
      extend Sodium

      sodium_type :aead
      sodium_primitive :chacha20poly1305
      sodium_constant :KEYBYTES
      sodium_constant :NPUBBYTES
      sodium_constant :ABYTES

      sodium_function :aead_chacha20poly1305_encrypt,
                      :crypto_aead_chacha20poly1305_encrypt,
                      %i[pointer pointer pointer ulong_long pointer ulong_long pointer pointer pointer]

      sodium_function :aead_chacha20poly1305_decrypt,
                      :crypto_aead_chacha20poly1305_decrypt,
                      %i[pointer pointer pointer pointer ulong_long pointer ulong_long pointer pointer]

      private

      def do_encrypt(ciphertext, ciphertext_len, nonce, message, additional_data)
        self.class.aead_chacha20poly1305_encrypt(ciphertext, ciphertext_len,
                                                 message, data_len(message),
                                                 additional_data, data_len(additional_data),
                                                 nil, nonce, @key)
      end

      def do_decrypt(message, message_len, nonce, ciphertext, additional_data)
        self.class.aead_chacha20poly1305_decrypt(message, message_len, nil,
                                                 ciphertext, data_len(ciphertext),
                                                 additional_data, data_len(additional_data),
                                                 nonce, @key)
      end
    end
  end
end
