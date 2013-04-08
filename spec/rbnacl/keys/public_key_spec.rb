# encoding: binary
require 'spec_helper'

describe Crypto::PublicKey do
  let(:alicepk)     { test_vector :alice_public }
  let(:alicepk_hex) { bytes2hex alicepk }

  subject { Crypto::PublicKey.new(alicepk) }

  context "new" do
    it "accepts a valid key" do
      expect { Crypto::PublicKey.new(alicepk) }.not_to raise_error
    end
    it "accepts a valid key in hex" do
      expect { Crypto::PublicKey.new(alicepk_hex, :hex) }.not_to raise_error
    end
    it "rejects a nil key" do
      expect { Crypto::PublicKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PublicKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      subject.to_bytes.should eq alicepk
    end
  end

  context "#to_s" do
    it "returns the bytes of the key" do
      subject.to_s.should eq alicepk
    end
    it "returns the bytes of the key hex encoded" do
      subject.to_s(:hex).should eq alicepk_hex
    end
  end

  include_examples "key equality" do
    let(:key) { subject }
    let(:key_bytes) { subject.to_bytes }
    let(:other_key) { described_class.new(alicepk.succ) }
  end
end
