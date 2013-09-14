# encoding: binary
require 'spec_helper'

describe RbNaCl::PublicKey do
  let(:alicepk)     { vector :alice_public }

  subject { RbNaCl::PublicKey.new(alicepk) }

  context "new" do
    it "accepts a valid key" do
      expect { RbNaCl::PublicKey.new(alicepk) }.not_to raise_error
    end

    it "rejects a nil key" do
      expect { RbNaCl::PublicKey.new(nil) }.to raise_error(TypeError)
    end

    it "rejects a short key" do
      expect { RbNaCl::PublicKey.new("short") }.to raise_error(ArgumentError)
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
  end

  include_examples "key equality" do
    let(:key) { subject }
    let(:key_bytes) { subject.to_bytes }
    let(:other_key) { described_class.new(alicepk.succ) }
  end

  include_examples "serializable"
end
