# encoding: binary

start = Time.now if $DEBUG

# NaCl/libsodium for Ruby
module RbNaCl
  class SelfTestFailure < RbNaCl::CryptoError; end

  # Self-test performed at startup
  module SelfTest
    module_function

    def vector(name)
      [TEST_VECTORS[name]].pack("H*")
    end

    def box_test
      alicepk = RbNaCl::PublicKey.new(vector(:alice_public))
      bobsk = RbNaCl::PrivateKey.new(vector(:bob_private))

      box = RbNaCl::Box.new(alicepk, bobsk)
      box_common_test(box)
    end

    def secret_box_test
      box = SecretBox.new(vector(:secret_key))
      box_common_test(box)
    end

    def box_common_test(box)
      nonce      = vector :box_nonce
      message    = vector :box_message
      ciphertext = vector :box_ciphertext

      raise SelfTestFailure, "failed to generate correct ciphertext" unless box.encrypt(nonce, message) == ciphertext
      raise SelfTestFailure, "failed to decrypt ciphertext correctly" unless box.decrypt(nonce, ciphertext) == message

      begin
        passed         = false
        corrupt_ct     = ciphertext.dup
        corrupt_ct[23] = " "
        box.decrypt(nonce, corrupt_ct)
      rescue CryptoError
        passed = true
      ensure
        passed || raise(SelfTestFailure, "failed to detect corrupt ciphertext")
      end
    end

    def digital_signature_test
      signing_key = SigningKey.new(vector(:sign_private))
      verify_key  = signing_key.verify_key

      unless verify_key.to_s == vector(:sign_public)
        #:nocov:
        raise SelfTestFailure, "failed to generate verify key correctly"
        #:nocov:
      end

      message   = vector :sign_message
      signature = signing_key.sign(message)

      unless signature == vector(:sign_signature)
        #:nocov:
        raise SelfTestFailure, "failed to generate correct signature"
        #:nocov:
      end

      unless verify_key.verify(signature, message)
        #:nocov:
        raise SelfTestFailure, "failed to verify a valid signature"
        #:nocov:
      end

      begin
        passed = false
        bad_signature = signature[0, 63] + "0"
        verify_key.verify(bad_signature, message)
      rescue CryptoError
        passed = true
      ensure
        passed || raise(SelfTestFailure, "failed to detect corrupt ciphertext")
      end
    end

    def sha256_test
      message = vector :sha256_message
      digest  = vector :sha256_digest

      raise SelfTestFailure, "failed to generate a correct SHA256 digest" unless RbNaCl::Hash.sha256(message) == digest
    end

    def hmac_test(klass, tag)
      authenticator = klass.new(vector("auth_key_#{klass.key_bytes}".to_sym))

      message = vector :auth_message

      raise SelfTestFailure, "#{klass} failed to generate correct authentication tag" unless authenticator.auth(message) == vector(tag)
      raise SelfTestFailure, "#{klass} failed to verify correct authentication tag" unless authenticator.verify(vector(tag), message)

      begin
        passed = false
        authenticator.verify(vector(tag), message + " ")
      rescue CryptoError
        passed = true
      ensure
        passed || raise(SelfTestFailure, "failed to detect corrupt ciphertext")
      end
    end
  end
end

RbNaCl::SelfTest.box_test
RbNaCl::SelfTest.secret_box_test
RbNaCl::SelfTest.digital_signature_test
RbNaCl::SelfTest.sha256_test
RbNaCl::SelfTest.hmac_test RbNaCl::HMAC::SHA256,    :auth_hmacsha256
RbNaCl::SelfTest.hmac_test RbNaCl::HMAC::SHA512256, :auth_hmacsha512256
RbNaCl::SelfTest.hmac_test RbNaCl::OneTimeAuth,     :auth_onetime

puts "POST Completed in #{Time.now - start} s" if $DEBUG
