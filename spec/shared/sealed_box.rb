# encoding: binary
# frozen_string_literal: true

RSpec.shared_examples "sealed_box" do
  let(:message)    { vector :box_message }
  let(:ciphertext) { vector :box_ciphertext }
  let(:corrupt_ciphertext) { ciphertext[80] = " " } # picked at random by fair diceroll

  context "box" do
    it "roundtrips" do
      ciphertext = box.box(message)
      expect(box.open(ciphertext)).to eq message
    end
  end

  context "open" do
    it "raises on a truncated message to decrypt" do
      expect do
        box.open(ciphertext[0, 64])
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a corrupt ciphertext" do
      expect do
        box.open(corrupt_ciphertext)
      end.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end
  end
end
