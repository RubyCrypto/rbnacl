# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::Box do
  let(:alicepk)   { vector :alice_public }
  let(:bobsk)     { vector :bob_private  }
  let(:alice_key) { RbNaCl::PublicKey.new(alicepk) }
  let(:bob_key)   { RbNaCl::PrivateKey.new(bobsk) }

  context "new" do
    it "accepts strings" do
      expect do
        RbNaCl::Box.new(alicepk, bobsk)
      end.to_not raise_error
    end

    it "accepts KeyPairs" do
      expect do
        RbNaCl::Box.new(alice_key, bob_key)
      end.to_not raise_error
    end

    it "raises TypeError on a nil public key" do
      expect do
        RbNaCl::Box.new(nil, bobsk)
      end.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid public key" do
      expect do
        RbNaCl::Box.new("hello", bobsk)
      end.to raise_error(RbNaCl::LengthError, /Public key was 5 bytes \(Expected 32\)/)
    end

    it "raises TypeError on a nil secret key" do
      expect do
        RbNaCl::Box.new(alicepk, nil)
      end.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid secret key" do
      expect do
        RbNaCl::Box.new(alicepk, "hello")
      end.to raise_error(RbNaCl::LengthError, /Private key was 5 bytes \(Expected 32\)/)
    end
  end

  include_examples "box" do
    let(:box) { RbNaCl::Box.new(alicepk, bobsk) }
  end
end
