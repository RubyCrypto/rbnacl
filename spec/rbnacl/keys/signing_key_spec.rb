# encoding: binary
require 'spec_helper'

describe Crypto::SigningKey do
  let(:signing_key_hex) { hex_vector :sign_private }
  let(:signing_key)     { hex2bytes signing_key_hex }

  let(:message)         { test_vector :sign_message }
  let(:signature)       { test_vector :sign_signature }

  # NOTE: this implicitly covers testing initialization from bytes
  subject { described_class.new(signing_key_hex, :hex) }

  it "generates keys" do
    described_class.generate.should be_a described_class
  end

  it "signs messages as bytes" do
    subject.sign(message).should eq signature
  end

  it "signs messages as hex" do
    subject.sign(message, :hex).should eq bytes2hex signature
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq signing_key_hex
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq signing_key
  end

  include_examples "key equality" do
    let(:key_bytes) { signing_key }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B"*32) }
  end
end
