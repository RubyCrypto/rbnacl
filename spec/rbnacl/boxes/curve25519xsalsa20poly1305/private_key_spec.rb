# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::PrivateKey do
  let(:bobsk) { vector :bob_private }
  let(:bobpk) { vector :bob_public }

  subject { RbNaCl::PrivateKey.new(bobsk) }

  context "generate" do
    let(:secret_key) { RbNaCl::PrivateKey.generate }

    it "returns a secret key" do
      expect(secret_key).to be_a RbNaCl::PrivateKey
    end

    it "has the public key also set" do
      expect(secret_key.public_key).to be_a RbNaCl::PublicKey
    end
  end

  context "new" do
    it "accepts a valid key" do
      expect { RbNaCl::PrivateKey.new(bobsk) }.not_to raise_error
    end

    it "raises TypeError when given a nil key" do
      expect { RbNaCl::PrivateKey.new(nil) }.to raise_error(TypeError)
    end

    it "raises ArgumentError when given a short key" do
      expect { RbNaCl::PrivateKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "public_key" do
    it "returns a public key" do
      expect(subject.public_key).to be_a RbNaCl::PublicKey
    end

    it "returns the correct public key" do
      expect(subject.public_key.to_s).to eql bobpk
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      expect(subject.to_s).to eq bobsk
    end
  end

  context "#to_s" do
    it "returns the raw bytes of the key" do
      expect(subject.to_bytes).to eq bobsk
    end
  end

  include_examples "key equality" do
    let(:key) { subject }
    let(:key_bytes) { subject.to_bytes }
    let(:other_key) { described_class.new(bobpk) }
  end

  include_examples "serializable"
end
