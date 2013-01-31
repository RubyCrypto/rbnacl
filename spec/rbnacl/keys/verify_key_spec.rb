describe Crypto::VerifyKey do
  let(:signing_key_bytes) { "A" * 32 }
  let(:verify_key_bytes)  { "\xDB\x99_\xE2Qi\xD1A\xCA\xB9\xBB\xBA\x92\xBA\xA0\x1F\x9F.\x1E\xCE}\xF4\xCB*\xC0Q\x90\xF3\x7F\xCC\x1F\x9D" }
  let(:verify_key_hex)    { verify_key_bytes.unpack("H*").first }

  let(:message)       { "example message" }
  let(:signature)     { "\e\x88\xB2X\xF67\xDC^\xF4\xA0\x023\a\xF32)\xD4cj%\xA8\x82\xB4\xED\x10\x8B\x19y\xB8r\xAE\xC7\xB1\x88@<OV\xAA\xB4\r]\xDC\xBC\xC1\xBEu5\xA2}\x95f\xA1/\xB5\x17\xC8\xC2\xB6\xB5e7\x00\x01" }
  let(:hex_signature) { signature.unpack("H*").first }
  let(:bad_signature) { sig = signature; sig[0] = (sig[0].ord + 1).chr; sig }

  subject { Crypto::SigningKey.new(signing_key_bytes).verify_key }

  it "verifies correct signatures" do
    subject.verify(message, signature).should be_true
  end

  it "verifies correct hex signatures" do
    subject.verify(message, hex_signature, :hex).should be_true
  end

  it "detects bad signatures" do
    subject.verify(message, bad_signature).should be_false
  end

  it "raises when asked to verify with a bang" do
    expect { subject.verify!(message, bad_signature) }.to raise_exception Crypto::BadSignatureError
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq verify_key_bytes
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq verify_key_hex
  end

  it "initializes from bytes" do
    described_class.new(verify_key_bytes).to_bytes.should eq verify_key_bytes
  end

  it "initializes from hex" do
    described_class.new(verify_key_hex, :hex).to_bytes.should eq verify_key_bytes
  end
end
