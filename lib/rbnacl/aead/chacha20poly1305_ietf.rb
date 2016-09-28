# encoding: binary
module RbNaCl
  module AEAD
    # This class contains wrappers for the IETF implementation of
    # Authenticated Encryption with Additional Data using ChaCha20-Poly1305
    class Chacha20Poly1305IETF < GenericAEAD
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

      private

      def do_encrypt(ciphertext, ciphertext_len, nonce, message, additional_data)
        self.class.aead_chacha20poly1305_ietf_encrypt(ciphertext, ciphertext_len,
                                                      message, message.bytesize,
                                                      additional_data, additional_data.bytesize,
                                                      nil, nonce, @key)
      end

      def do_decrypt(message, message_len, nonce, ciphertext, additional_data)
        self.class.aead_chacha20poly1305_ietf_decrypt(message, message_len, nil,
                                                      ciphertext, ciphertext.bytesize,
                                                      additional_data, additional_data.bytesize,
                                                      nonce, @key)
      end
    end
  end
end
