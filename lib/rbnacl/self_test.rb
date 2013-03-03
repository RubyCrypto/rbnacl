module Crypto
  class SelfTestFailure < Crypto::CryptoError; end

  module SelfTest
    module_function

    def secret_box_test
      box = SecretBox.new(TestVectors[:secret_key], :hex)

      nonce      = Encoder[:hex].decode TestVectors[:box_nonce]
      message    = Encoder[:hex].decode TestVectors[:box_message]
      ciphertext = Encoder[:hex].decode TestVectors[:box_ciphertext]

      unless box.encrypt(nonce, message) == ciphertext
        raise SelfTestFailure, "failed to generate correct ciphertext"
      end
    end

    def digital_signature_test
      signing_key = SigningKey.new(TestVectors[:sign_private], :hex)
      verify_key  = signing_key.verify_key

      unless verify_key.to_s(:hex) == TestVectors[:sign_public]
        raise SelfTestFailure, "failed to generate verify key correctly"
      end

      message   = Encoder[:hex].decode TestVectors[:sign_message]
      signature = signing_key.sign(message, :hex)

      unless signature == TestVectors[:sign_signature]
        raise SelfTestFailure, "failed to generate correct signature"
      end

      unless verify_key.verify(message, signature, :hex)
        raise SelfTestFailure, "failed to verify a valid signature"
      end

      bad_signature = signature[0,127] + '0'

      unless verify_key.verify(message, bad_signature, :hex) == false
        raise SelfTestFailure, "failed to detect an invalid signature"
      end
    end
  end
end

Crypto::SelfTest.secret_box_test
Crypto::SelfTest.digital_signature_test