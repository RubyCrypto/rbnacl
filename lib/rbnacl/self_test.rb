module Crypto
  class SelfTestFailure < Crypto::CryptoError; end

  module SelfTest
    module_function

    def box_test
      alicepk = Crypto::PublicKey.new(TestVectors[:alice_public], :hex)
      bobsk = Crypto::PrivateKey.new(TestVectors[:bob_private], :hex)

      box = Crypto::Box.new(alicepk, bobsk)
      box_common_test(box)
    end

    def secret_box_test
      box = SecretBox.new(TestVectors[:secret_key], :hex)
      box_common_test(box)
    end

    def box_common_test(box)
      nonce      = Encoder[:hex].decode TestVectors[:box_nonce]
      message    = Encoder[:hex].decode TestVectors[:box_message]
      ciphertext = Encoder[:hex].decode TestVectors[:box_ciphertext]

      unless box.encrypt(nonce, message) == ciphertext
        raise SelfTestFailure, "failed to generate correct ciphertext"
      end

      unless box.decrypt(nonce, ciphertext) == message
        raise SelfTestFailure, "failed to decrypt ciphertext correctly"
      end

      begin
        passed         = false
        corrupt_ct     = ciphertext.dup
        corrupt_ct[23] = ' '
        box.decrypt(nonce, corrupt_ct)
      rescue CryptoError
        passed = true
      ensure
        passed or raise SelfTestFailure, "failed to detect corrupt ciphertext"
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

    def hmac_test(klass, tag)
      authenticator = klass.new(TestVectors[:auth_key], :hex)

      message = Encoder[:hex].decode TestVectors[:auth_message]

      unless authenticator.auth(message, :hex) == TestVectors[tag]
        raise SelfTestFailure, "#{klass} failed to generate correct authentication tag"
      end

      unless authenticator.verify(message, TestVectors[tag], :hex)
        raise SelfTestFailure, "#{klass} failed to verify correct authentication tag"
      end

      if authenticator.verify(message+' ', TestVectors[tag], :hex)
        raise SelfTestFailure, "#{klass} failed to detect invalid authentication tag"
      end
    end
  end
end

Crypto::SelfTest.box_test
Crypto::SelfTest.secret_box_test
Crypto::SelfTest.digital_signature_test
Crypto::SelfTest.hmac_test Crypto::HMAC::SHA256,    :auth_hmacsha256
Crypto::SelfTest.hmac_test Crypto::HMAC::SHA512256, :auth_hmacsha512256
Crypto::SelfTest.hmac_test Crypto::Auth::OneTime,   :auth_onetime
