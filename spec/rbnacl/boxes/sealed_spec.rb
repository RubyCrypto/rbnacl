# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::SealedBox do
  let(:alicepk)   { vector :alice_public }
  let(:alicesk)   { vector :alice_private }
  let(:alice_pubkey) { RbNaCl::PublicKey.new(alicepk) }
  let(:alice_privkey) { RbNaCl::PrivateKey.new(alicesk) }

  context "new" do
    it "accepts public key strings" do
      expect do
        RbNaCl::SealedBox.from_public_key(alicepk)
      end.to_not raise_error
    end

    it "accepts public KeyPairs" do
      expect do
        RbNaCl::SealedBox.from_public_key(alice_pubkey)
      end.to_not raise_error
    end

    it "accepts private key strings" do
      expect do
        RbNaCl::SealedBox.from_private_key(alicepk)
      end.to_not raise_error
    end

    it "accepts private KeyPairs" do
      expect do
        RbNaCl::SealedBox.from_private_key(alice_privkey)
      end.to_not raise_error
    end

    it "raises TypeError on a nil public key" do
      expect do
        RbNaCl::SealedBox.from_public_key(nil)
      end.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid public key" do
      expect do
        RbNaCl::SealedBox.from_public_key("hello")
      end.to raise_error(RbNaCl::LengthError, /Public key was 5 bytes \(Expected 32\)/)
    end

    it "raises TypeError on a nil private key" do
      expect do
        RbNaCl::SealedBox.from_private_key(nil)
      end.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid private key" do
      expect do
        RbNaCl::SealedBox.from_private_key("hello")
      end.to raise_error(RbNaCl::LengthError, /Private key was 5 bytes \(Expected 32\)/)
    end
  end

  include_examples "sealed_box" do
    let(:box) { RbNaCl::SealedBox.new(alicepk, alicesk) }
  end
end
