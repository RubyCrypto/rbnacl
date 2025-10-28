# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::SecretBoxes::XChaCha20Poly1305 do
  let(:key)   { vector :secretbox_xchacha20poly1305_key }
  let(:box)   { described_class.new(key) }

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
  end


  include_examples "box" do
    let(:nonce)      { vector :secretbox_xchacha20poly1305_nonce }
    let(:message)    { vector :secretbox_xchacha20poly1305_message }
    let(:ciphertext) { vector :secretbox_xchacha20poly1305_ciphertext }
  end
end
