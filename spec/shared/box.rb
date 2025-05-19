# encoding: binary
# frozen_string_literal: true

RSpec.shared_examples "box" do
  let(:nonce) { vector :box_nonce }
  let(:invalid_nonce) { nonce[0, 12] } # too short!
  let(:invalid_nonce_long) { nonce + nonce } # too long!
  let(:message)    { vector :box_message }
  let(:ciphertext) { vector :box_ciphertext }
  let(:nonce_error_regex) { /Nonce.*(Expected #{box.nonce_bytes})/ }
  let(:corrupt_ciphertext) { ciphertext[80] = " " } # picked at random by fair diceroll

  context "box" do
    it "encrypts a message" do
      expect(box.box(nonce, message)).to eq ciphertext
    end

    it "raises on a short nonce" do
      expect do
        box.box(invalid_nonce, message)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect do
        box.box(invalid_nonce_long, message)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end

  context "open" do
    it "decrypts a message" do
      expect(box.open(nonce, ciphertext)).to eq message
    end

    it "raises on a truncated message to decrypt" do
      expect do
        box.open(nonce, ciphertext[0, 64])
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a message too short to contain the authentication tag" do
      expect do
        box.open(nonce, ciphertext[0, 7])
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a corrupt ciphertext" do
      expect do
        box.open(nonce, corrupt_ciphertext)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a short nonce" do
      expect do
        box.open(invalid_nonce, message)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect do
        box.open(invalid_nonce_long, message)
      end.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end
end
