# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::SigningKey do
  let(:signing_key)     { vector :sign_private }
  let(:signing_keypair) { vector :sign_keypair }
  let(:message)         { vector :sign_message }
  let(:signature)       { vector :sign_signature }

  subject { described_class.new(signing_key) }

  it "generates keys" do
    expect(described_class.generate).to be_a described_class
  end

  it "signs messages as bytes" do
    expect(subject.sign(message)).to eq signature
  end

  it "signs messages, full version" do
    expect(subject.sign_attached(message)[0, RbNaCl::SigningKey.signature_bytes]).to eq signature
    expect(subject.sign_attached(message)[RbNaCl::SigningKey.signature_bytes, message.length]).to eq message
  end

  it "serializes to bytes" do
    expect(subject.to_bytes).to eq signing_key
  end

  it "serializes the internal signing key to bytes" do
    expect(subject.keypair_bytes.length).to eq 64
    expect(subject.keypair_bytes).to eq signing_keypair
  end

  include_examples "key equality" do
    let(:key_bytes) { signing_key }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B" * 32) }
  end

  include_examples "serializable"
end
