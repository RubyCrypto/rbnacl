# encoding: binary
require 'spec_helper'

describe Crypto::RandomNonceBox do
  let (:secret_key) { test_vector :secret_key }
  let(:secret_box) { Crypto::SecretBox.new(secret_key) }
  let (:alicepk) { test_vector :alice_public  } 
  let (:bobsk) { test_vector :bob_private  } 

  context "instantiation" do
    it "can be instantiated from an already existing box" do
      expect { Crypto::RandomNonceBox.new(secret_box) }.not_to raise_error
    end

    it "can be instantiated from a secret key" do
      Crypto::RandomNonceBox.from_secret_key(secret_key).should be_a Crypto::RandomNonceBox
    end
    it "complains on an inappropriate secret key" do
      expect { Crypto::RandomNonceBox.from_secret_key(nil) }.to raise_error(ArgumentError)
    end
    it "can be instantiated from a key-pair" do
      Crypto::RandomNonceBox.from_keypair(alicepk, bobsk).should be_a Crypto::RandomNonceBox
    end
    it "complains on an inappropriate key in the pair" do
      expect { Crypto::RandomNonceBox.from_keypair(nil, bobsk) }.to raise_error(ArgumentError)
    end
  end



  context "cryptography" do
    let(:nonce)      { test_vector :box_nonce }
    let(:message)    { test_vector :box_message } 
    let(:ciphertext) { test_vector :box_ciphertext  }
    let(:random_box) { Crypto::RandomNonceBox.new(secret_box) }
    let(:enciphered_message) { random_box.box(message) }
    let(:enciphered_message_hex) { random_box.box(message, :hex) }

    it "descrypts a message with a 'random' nonce" do
      random_box.open(nonce+ciphertext).should eql message
    end

    it "can successfully round-trip a message" do
      random_box.open(enciphered_message).should eql message
    end

    it "can encode a ciphertext as hex" do
      enciphered_message_hex.should match /\A[0-9a-f]+\z/
    end
    it "can roundtrip a message as hex" do
      random_box.open(enciphered_message_hex, :hex).should eql message
    end

    it "reports the box's underlying primitive" do
      random_box.primitive.should be secret_box.primitive
    end
  end
end
