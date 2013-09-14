# encoding: binary
require 'spec_helper'

describe RbNaCl::SigningKey do
  let(:signing_key) { vector :sign_private }
  let(:message)     { vector :sign_message }
  let(:signature)   { vector :sign_signature }

  subject { described_class.new(signing_key) }

  it "generates keys" do
    described_class.generate.should be_a described_class
  end

  it "signs messages as bytes" do
    subject.sign(message).should eq signature
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq signing_key
  end

  include_examples "key equality" do
    let(:key_bytes) { signing_key }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B"*32) }
  end

  include_examples "serializable"
end
