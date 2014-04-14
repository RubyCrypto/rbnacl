# encoding: binary

shared_examples "box" do
  let(:nonce) { vector :box_nonce }
  let(:invalid_nonce) { nonce[0,12]  } # too short!
  let(:invalid_nonce_long) { nonce + nonce  } # too long!
  let(:message)    { vector :box_message }
  let(:ciphertext) { vector :box_ciphertext }
  let (:nonce_error_regex) { /Nonce.*(Expected #{box.nonce_bytes})/ }
  let(:corrupt_ciphertext) { ciphertext[80] = " " } # picked at random by fair diceroll

  context "box" do

    it "encrypts a message" do
      box.box(nonce, message).should eq ciphertext
    end

    it "raises on a short nonce" do
      expect { box.box(invalid_nonce, message) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect { box.box(invalid_nonce_long, message) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end

  context "open" do

    it "decrypts a message" do
      box.open(nonce, ciphertext).should eq message
    end

    it "raises on a truncated message to decrypt" do
      expect { box.open(nonce, ciphertext[0, 64]) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a corrupt ciphertext" do
      expect { box.open(nonce, corrupt_ciphertext) }.to raise_error(RbNaCl::CryptoError, /Decryption failed. Ciphertext failed verification./)
    end

    it "raises on a short nonce" do
      expect { box.open(invalid_nonce, message) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end

    it "raises on a long nonce" do
      expect { box.open(invalid_nonce_long, message) }.to raise_error(RbNaCl::LengthError, nonce_error_regex)
    end
  end
end
