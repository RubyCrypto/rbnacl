# encoding: binary
module RbNaCl
  module AEAD
    # This class contains wrappers for the IETF implementation of
    # Authenticated Encryption with Additional Data using ChaCha20-Poly1305
    class Chacha20Poly1305IETF < GenericAEAD
      extend Sodium
      if Sodium::Version.supported_version?("1.0.9")
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
                                                        message, data_len(message),
                                                        additional_data, data_len(additional_data),
                                                        nil, nonce, @key)
        end

        def do_decrypt(message, message_len, nonce, ciphertext, additional_data)
          self.class.aead_chacha20poly1305_ietf_decrypt(message, message_len, nil,
                                                        ciphertext, data_len(ciphertext),
                                                        additional_data, data_len(additional_data),
                                                        nonce, @key)
        end
      end
    end
  end
end
