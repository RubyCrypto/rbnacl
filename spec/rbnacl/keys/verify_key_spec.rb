describe Crypto::VerifyKey do
  let(:signing_key)    { Crypto::TestVectors[:alice_private] }
  let(:verify_key)     { Crypto::TestVectors[:alice_verify] }
  let(:verify_key_raw) { Crypto::Encoder[:hex].decode(verify_key) }

  let(:message)        { Crypto::Encoder[:hex].decode(Crypto::TestVectors[:message]) }
  let(:signature)      { Crypto::TestVectors[:signature] }
  let(:signature_raw)  { Crypto::Encoder[:hex].decode(signature) }
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
