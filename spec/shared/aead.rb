# encoding: binary
# frozen_string_literal: true

RSpec.shared_examples "aead" do
  let(:corrupt_ciphertext) { ciphertext.succ }
  let(:trunc_ciphertext)   { ciphertext[0, 20] }
  let(:invalid_nonce)      { nonce[0, nonce.bytesize / 2] } # too short!
  let(:invalid_nonce_long) { nonce + nonce } # too long!
  let(:nonce_error_regex)  { /Nonce.*(Expected #{aead.nonce_bytes})/ }
  let(:corrupt_ad)         { ad.succ }
  let(:trunc_ad)           { ad[0, ad.bytesize / 2] }

  let(:aead) { described_class.new(key) }

  context "new" do
    it "accepts strings" do
      expect { described_class.new(key) }.to_not raise_error
    end

    it "raises on a nil key" do
      expect { described_class.new(nil) }.to raise_error(TypeError)
    end

    it "raises on a short key" do
      expect { described_class.new("hello") }.to raise_error RbNaCl::LengthError
    end

    it "raises on a long key" do
      expect { described_class.new("hello" + key) }.to raise_error RbNaCl::LengthError
    end
  end

  context "encrypt" do
    it "encrypts a message" do
      expect(aead.encrypt(nonce, message, ad)).to eq ciphertext
    end

    it "raises on a short nonce" do
      expect do
        aead.encrypt(invalid_nonce, message, ad)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect do
        aead.encrypt(invalid_nonce_long, message, ad)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "works with an empty message" do
      expect do
        aead.encrypt(nonce, nil, ad)
      end.to_not raise_error
    end

    it "works with an empty additional data" do
      expect do
        aead.encrypt(nonce, message, nil)
      end.to_not raise_error
    end
  end

  context "decrypt" do
    it "decrypts a message" do
      expect(aead.decrypt(nonce, ciphertext, ad)).to eq message
    end

    it "raises on a truncated message to decrypt" do
      expect do
        aead.decrypt(nonce, trunc_ciphertext, ad)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a corrupt ciphertext" do
      expect do
        aead.decrypt(nonce, corrupt_ciphertext, ad)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises when the additional data is truncated" do
      expect do
        aead.decrypt(nonce, ciphertext, corrupt_ad)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises when the additional data is corrupt " do
      expect do
        aead.decrypt(nonce, ciphertext, trunc_ad)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a short nonce" do
      expect do
        aead.decrypt(invalid_nonce, message, ad)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect do
        aead.decrypt(invalid_nonce_long, message, ad)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end
end
