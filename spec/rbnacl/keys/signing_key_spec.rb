require 'spec_helper'

describe Crypto::SigningKey do
  let(:signing_key)     { Crypto::TestVectors[:alice_private] }
  let(:signing_key_raw) { Crypto::Encoder[:hex].decode(signing_key) }

  let(:message)         { "Now is the time for all good men to come to the aid of their country" }
  let(:signature)       { Crypto::TestVectors[:signature] }
  let(:signature_raw)   { Crypto::Encoder[:hex].decode(signature) }

  # NOTE: this implicitly covers testing initialization from bytes
  subject { described_class.new(signing_key, :hex) }

  it "generates keys" do
    described_class.generate.should be_a described_class
  end

  it "signs messages as bytes" do
    subject.sign(message).should eq signature_raw
  end

  it "signs messages as hex" do
    subject.sign(message, :hex).should eq signature
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq signing_key
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq signing_key_raw
  end
  
  include_examples "key equality" do
    let(:key_bytes) { signing_key_raw }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B"*32) }
  end
end
