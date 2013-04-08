# encoding: binary
describe Crypto::VerifyKey do
  let(:signing_key)    { hex_vector :sign_private }
  let(:verify_key)     { hex_vector :sign_public }
  let(:verify_key_raw) { hex2bytes verify_key }

  let(:message)        { test_vector :sign_message }
  let(:signature)      { hex_vector :sign_signature }
  let(:signature_raw)  { hex2bytes signature }
  let(:bad_signature)  { sig = signature.dup; sig[0] = (sig[0].ord + 1).chr; sig }

  subject { Crypto::SigningKey.new(signing_key, :hex).verify_key }

  it "verifies correct signatures" do
    subject.verify(message, signature_raw).should be_true
  end

  it "verifies correct hex signatures" do
    subject.verify(message, signature, :hex).should be_true
  end

  it "detects bad signatures" do
    subject.verify(message, bad_signature, :hex).should be_false
  end

  it "raises when asked to verify with a bang" do
    expect { subject.verify!(message, bad_signature, :hex) }.to raise_exception Crypto::BadSignatureError
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq verify_key_raw
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq verify_key
  end

  it "initializes from bytes" do
    described_class.new(verify_key_raw).to_s(:hex).should eq verify_key
  end

  it "initializes from hex" do
    described_class.new(verify_key, :hex).to_s(:hex).should eq verify_key
  end

  include_examples "key equality" do
    let(:key_bytes) { verify_key_raw }
    let(:key)       { described_class.new(key_bytes) }
    let(:other_key) { described_class.new("B"*32) }
  end
end
