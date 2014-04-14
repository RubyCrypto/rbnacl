# encoding: binary
require 'spec_helper'

describe RbNaCl::SimpleBox do
  let(:secret_key) { vector :secret_key }
  let(:secret_box) { RbNaCl::SecretBox.new(secret_key) }
  let(:alicepk)    { vector :alice_public }
  let(:alicesk)    { vector :alice_private }
  let(:bobpk)      { vector :bob_public }
  let(:bobsk)      { vector :bob_private }

  context "instantiation" do
    it "can be instantiated from an already existing box" do
      expect { described_class.new(secret_box) }.not_to raise_error
    end

    it "can be instantiated from a secret key" do
      described_class.from_secret_key(secret_key).should be_a described_class
    end

    it "raises TypeError when given a nil secret key" do
      expect { described_class.from_secret_key(nil) }.to raise_error(TypeError)
    end

    it "can be instantiated from a key-pair" do
      described_class.from_keypair(alicepk, bobsk).should be_a described_class
    end

    it "raises TypeError when given nil secret keys in the pair" do
      expect { described_class.from_keypair(nil, bobsk) }.to raise_error(TypeError)
      expect { described_class.from_keypair(alicepk, nil) }.to raise_error(TypeError)
    end
  end

  context "cryptography" do
    let(:nonce)      { vector :box_nonce }
    let(:message)    { vector :box_message }
    let(:ciphertext) { vector :box_ciphertext }
    let(:alice) { described_class.from_keypair(bobpk, alicesk) }
    let(:bob) { described_class.from_keypair(alicepk, bobsk) }

    describe "bob" do
      it "decrypts a message from alice" do
        alices_ciphertext = alice.encrypt(message)
        bob.decrypt(alices_ciphertext).should eql message
      end

      it "decrypts own message" do
        bobs_ciphertext = bob.encrypt(message)
        bob.decrypt(bobs_ciphertext).should eql message
      end

      it "decrypts a message with a 'random' nonce" do
        bob.decrypt(nonce+ciphertext).should eql message
      end
    end
  end
end
