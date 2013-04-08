# encoding: binary
require 'spec_helper'

describe Crypto::PrivateKey do
  let(:bobsk)     { test_vector :bob_private }
  let(:bobsk_hex) { bytes2hex bobsk }
  let(:bobpk)     { test_vector :bob_public }
  let(:bobpk_hex) { bytes2hex bobpk }

  subject { Crypto::PrivateKey.new(bobsk) }

  context "generate" do
    let(:secret_key) { Crypto::PrivateKey.generate }

    it "returns a secret key" do
      secret_key.should be_a Crypto::PrivateKey
    end

    it "has the public key also set" do
      secret_key.public_key.should be_a Crypto::PublicKey
    end
  end

  context "new" do
    it "accepts a valid key" do
      expect { Crypto::PrivateKey.new(bobsk) }.not_to raise_error
    end
    it "accepts a hex encoded key" do
      expect { Crypto::PrivateKey.new(bobsk_hex, :hex) }.not_to raise_error
    end
    it "rejects a nil key" do
      expect { Crypto::PrivateKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PrivateKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "public_key" do
    it "returns a public key" do
      subject.public_key.should be_a Crypto::PublicKey
    end
    it "returns the correct public key" do
      subject.public_key.to_s(:hex).should eql bobpk_hex
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      subject.to_s(:hex).should eq bobsk_hex
    end
  end

  context "#to_s" do
    it "returns the bytes of the key hex encoded" do
      subject.to_s(:hex).should eq bobsk_hex
    end
    it "returns the raw bytes of the key" do
      subject.to_bytes.should eq bobsk
    end
  end

  include_examples "key equality" do
    let(:key) { subject }
    let(:key_bytes) { subject.to_bytes }
    let(:other_key) { described_class.new(bobpk) }
  end
end
