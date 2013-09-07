# encoding: binary
require 'spec_helper'

describe RbNaCl::Box do
  let(:alicepk)   { vector :alice_public }
  let(:bobsk)     { vector :bob_private  }
  let(:alice_key) { RbNaCl::PublicKey.new(alicepk) }
  let(:bob_key)   { RbNaCl::PrivateKey.new(bobsk) }

  context "new" do
    it "accepts strings" do
      expect { RbNaCl::Box.new(alicepk, bobsk) }.to_not raise_error(Exception)
    end

    it "accepts KeyPairs" do
      expect { RbNaCl::Box.new(alice_key, bob_key) }.to_not raise_error(Exception)
    end

    it "raises TypeError on a nil public key" do
      expect { RbNaCl::Box.new(nil, bobsk) }.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid public key" do
      expect { RbNaCl::Box.new("hello", bobsk) }.to raise_error(RbNaCl::LengthError, /Public key was 5 bytes \(Expected 32\)/)
    end

    it "raises TypeError on a nil secret key" do
      expect { RbNaCl::Box.new(alicepk, nil) }.to raise_error(TypeError)
    end

    it "raises RbNaCl::LengthError on an invalid secret key" do
      expect { RbNaCl::Box.new(alicepk, "hello") }.to raise_error(RbNaCl::LengthError, /Private key was 5 bytes \(Expected 32\)/)
    end
  end

  include_examples 'box' do
    let(:box) { RbNaCl::Box.new(alicepk, bobsk) }
  end
end
