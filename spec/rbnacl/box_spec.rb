# encoding: binary
require 'spec_helper'

describe Crypto::Box do
  let(:alicepk)   { vector :alice_public }
  let(:bobsk)     { vector :bob_private  }
  let(:alice_key) { Crypto::PublicKey.new(alicepk) }
  let(:bob_key)   { Crypto::PrivateKey.new(bobsk) }

  context "new" do
    it "accepts strings" do
      expect { Crypto::Box.new(alicepk, bobsk) }.to_not raise_error(Exception)
    end

    it "accepts KeyPairs" do
      expect { Crypto::Box.new(alice_key, bob_key) }.to_not raise_error(Exception)
    end

    it "raises TypeError on a nil public key" do
      expect { Crypto::Box.new(nil, bobsk) }.to raise_error(TypeError)
    end

    it "raises Crypto::LengthError on an invalid public key" do
      expect { Crypto::Box.new("hello", bobsk) }.to raise_error(Crypto::LengthError, /Public key was 5 bytes \(Expected 32\)/)
    end

    it "raises TypeError on a nil secret key" do
      expect { Crypto::Box.new(alicepk, nil) }.to raise_error(TypeError)
    end

    it "raises Crypto::LengthError on an invalid secret key" do
      expect { Crypto::Box.new(alicepk, "hello") }.to raise_error(Crypto::LengthError, /Private key was 5 bytes \(Expected 32\)/)
    end
  end

  include_examples 'box' do
    let(:box) { Crypto::Box.new(alicepk, bobsk) }
  end
end
