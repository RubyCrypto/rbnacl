# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::SigningKey do
  let(:signing_key) { vector :sign_private }
  let(:message)     { vector :sign_message }
  let(:signature)   { vector :sign_signature }

  subject { described_class.new(signing_key) }

  it "generates keys" do
    expect(described_class.generate).to be_a described_class
  end

  it "signs messages as bytes" do
    expect(subject.sign(message)).to eq signature
  end

  it "serializes to bytes" do
    expect(subject.to_bytes).to eq signing_key
  end

  it "serializes the internal signing key to bytes" do
    expect(subject.keypair_bytes.length).to eq 64
    expect(subject.keypair_bytes).to eq "\xB1\x8E\x1D\x00E\x99^\xC3\xD0\x10\xC3\x87\xCC\xFE\xB9\x84\xD7\x83\xAF\x8F\xBB\x0F@\xFA}\xB1&\xD8\x89\xF6\xDA\xDDw\xF4\x8BY\xCA\xED\xA7wQ\xED\x13\x8B\x0E\xC6g\xFFP\xF8v\x8C%\xD4\x83\t\xA8\xF3\x86\xA2\xBA\xD1\x87\xFB"
  end

  include_examples "key equality" do
    let(:key_bytes) { signing_key }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B" * 32) }
  end

  include_examples "serializable"
end
