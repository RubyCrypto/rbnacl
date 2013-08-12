# encoding: binary
describe Crypto::VerifyKey do
  let(:signing_key)    { vector :sign_private }
  let(:verify_key)     { vector :sign_public }

  let(:message)        { vector :sign_message }
  let(:signature)      { vector :sign_signature }
  let(:bad_signature)  { sig = signature.dup; sig[0] = (sig[0].ord + 1).chr; sig }

  subject { Crypto::SigningKey.new(signing_key).verify_key }

  it "verifies correct signatures" do
    subject.verify(message, signature).should be_true
  end

  it "detects bad signatures" do
    subject.verify(message, bad_signature).should be_false
  end

  it "raises when asked to verify with a bang" do
    expect { subject.verify!(message, bad_signature) }.to raise_exception Crypto::BadSignatureError
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq verify_key
  end

  it "initializes from bytes" do
    described_class.new(verify_key).to_s.should eq verify_key
  end

  include_examples "key equality" do
    let(:key_bytes) { verify_key }
    let(:key)       { described_class.new(verify_key) }
    let(:other_key) { described_class.new("B"*32) }
  end
end
