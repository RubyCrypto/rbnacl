# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::AEAD::Chacha20Poly1305 do
  let(:key) {vector :aead_chacha20poly1305_orig_key}
  let(:message) {vector :aead_chacha20poly1305_orig_message}
  let(:nonce) {vector :aead_chacha20poly1305_orig_nonce}
  let(:ad) {vector :aead_chacha20poly1305_orig_ad}
  let(:ciphertext) {vector :aead_chacha20poly1305_orig_ciphertext}

  let(:aead) { RbNaCl::AEAD::Chacha20Poly1305.new(key) }

  let(:corrupt_ciphertext) { ciphertext.succ}
  let(:trunc_ciphertext) { ciphertext[0, 20]}
  let(:invalid_nonce) { nonce[0, nonce.bytesize/2] } # too short!
  let(:invalid_nonce_long) { nonce + nonce } # too long!
  let(:nonce_error_regex) { /Nonce.*(Expected #{aead.nonce_bytes})/ }
  let(:corrupt_ad) {ad.succ}
  let(:trunc_ad) {ad[0, ad.bytesize/2]}

  context "new" do
    it "accepts strings" do
      expect { RbNaCl::AEAD::Chacha20Poly1305.new(key) }.to_not raise_error
    end

    it "raises on a nil key" do
      expect { RbNaCl::AEAD::Chacha20Poly1305.new(nil) }.to raise_error(TypeError)
    end

    it "raises on a short key" do
      expect { RbNaCl::AEAD::Chacha20Poly1305.new("hello") }.to raise_error RbNaCl::LengthError
    end

    it "raises on a long key" do
      expect { RbNaCl::AEAD::Chacha20Poly1305.new("hello" + key) }.to raise_error RbNaCl::LengthError
    end
  end

  context "encrypt" do
    it "encrypts a message" do
      expect(aead.encrypt(nonce, message, ad)).to eq ciphertext
    end

    it "raises on a short nonce" do
      expect { aead.encrypt(invalid_nonce, message, ad) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect { aead.encrypt(invalid_nonce_long, message, ad) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end

  context "decrypt" do
    it "decrypts a message" do
      expect(aead.decrypt(nonce, ciphertext, ad)).to eq message
    end

    it "raises on a truncated message to decrypt" do
      expect { aead.decrypt(nonce, trunc_ciphertext, ad) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a corrupt ciphertext" do
      expect { aead.decrypt(nonce, corrupt_ciphertext, ad) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises when the additional data is truncated" do
      expect { aead.decrypt(nonce, ciphertext, corrupt_ad) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises when the additional data is corrupt " do
      expect { aead.decrypt(nonce, ciphertext, trunc_ad) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a short nonce" do
      expect { aead.decrypt(invalid_nonce, message, ad) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect { aead.decrypt(invalid_nonce_long, message, ad) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end
end
