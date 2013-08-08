# encoding: binary
require 'spec_helper'

describe Crypto::RandomNonceBox do
  let(:secret_key) { vector :secret_key }
  let(:secret_box) { Crypto::SecretBox.new(secret_key) }
  let(:alicepk)    { vector :alice_public }
  let(:bobsk)      { vector :bob_private }

  context "instantiation" do
    it "can be instantiated from an already existing box" do
      expect { Crypto::RandomNonceBox.new(secret_box) }.not_to raise_error
    end

    it "can be instantiated from a secret key" do
      Crypto::RandomNonceBox.from_secret_key(secret_key).should be_a Crypto::RandomNonceBox
    end

    it "complains on an inappropriate secret key" do
      expect { Crypto::RandomNonceBox.from_secret_key(nil) }.to raise_error(NoMethodError)
      pending "is a failed #to_s (NoMethodError) here sufficient?"
    end

    it "can be instantiated from a key-pair" do
      Crypto::RandomNonceBox.from_keypair(alicepk, bobsk).should be_a Crypto::RandomNonceBox
    end

    it "complains on an inappropriate key in the pair" do
      expect { Crypto::RandomNonceBox.from_keypair(nil, bobsk) }.to raise_error(NoMethodError)
      pending "is a failed #to_s (NoMethodError) here sufficient?"
    end
  end

  context "cryptography" do
    let(:nonce)      { vector :box_nonce }
    let(:message)    { vector :box_message }
    let(:ciphertext) { vector :box_ciphertext }
    let(:random_box) { Crypto::RandomNonceBox.from_keypair(alicepk, bobsk) }
    let(:enciphered_message) { random_box.box(message) }
    let(:enciphered_message_hex) { random_box.box(message) }

    it "descrypts a message with a 'random' nonce" do
      random_box.open(nonce+ciphertext).should eql message
    end

    it "can successfully round-trip a message" do
      random_box.open(enciphered_message).should eql message
    end
  end
end
