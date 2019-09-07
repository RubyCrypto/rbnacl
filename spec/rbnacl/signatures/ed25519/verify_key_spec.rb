# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::VerifyKey do
  let(:signing_key) { vector :sign_private }
  let(:verify_key)  { vector :sign_public }

  let(:message)     { vector :sign_message }
  let(:signature)   { vector :sign_signature }

  let(:bad_signature) do
    sig = signature.dup
    sig[0] = (sig[0].ord + 1).chr
    sig
  end

  subject { RbNaCl::SigningKey.new(signing_key).verify_key }

  it "verifies correct signatures" do
    expect(subject.verify(signature, message)).to eq true
  end

  it "verifies correct signatures, full version" do
    expect(subject.verify_attached(signature + message)).to eq true
  end

  it "raises when asked to verify a bad signature" do
    expect { subject.verify(bad_signature, message) }.to raise_exception RbNaCl::BadSignatureError
  end

  it "raises when asked to verify a bad signature, full version" do
    expect { subject.verify_attached(bad_signature + message) }.to raise_exception RbNaCl::BadSignatureError
  end

  it "raises when asked to verify a short signature" do
    expect { subject.verify(bad_signature[0, 63], message) }.to raise_exception RbNaCl::LengthError
  end

  it "raises when asked to verify a nil signed message" do
    expect { subject.verify_attached(nil) }.to raise_exception RbNaCl::LengthError
  end

  it "raises when asked to verify too short signed message" do
    expect { subject.verify_attached(signature) }.to raise_exception RbNaCl::LengthError
  end

  it "serializes to bytes" do
    expect(subject.to_bytes).to eq verify_key
  end

  it "initializes from bytes" do
    expect(described_class.new(verify_key).to_s).to eq verify_key
  end

  include_examples "key equality" do
    let(:key_bytes) { verify_key }
    let(:key)       { described_class.new(verify_key) }
    let(:other_key) { described_class.new("B" * 32) }
  end

  include_examples "serializable"
end
