require 'spec_helper'

describe Crypto::SigningKey do
  let(:signing_key_bytes) { "A" * 32 }
  let(:signing_key_hex)   { signing_key_bytes.unpack("H*").first }

  let(:message)         { "example message" }
  let(:signature_bytes) { "\e\x88\xB2X\xF67\xDC^\xF4\xA0\x023\a\xF32)\xD4cj%\xA8\x82\xB4\xED\x10\x8B\x19y\xB8r\xAE\xC7\xB1\x88@<OV\xAA\xB4\r]\xDC\xBC\xC1\xBEu5\xA2}\x95f\xA1/\xB5\x17\xC8\xC2\xB6\xB5e7\x00\x01" }
  let(:signature_hex)   { signature_bytes.unpack("H*").first }

  # NOTE: this implicitly covers testing initialization from bytes
  subject { described_class.new(signing_key_bytes) }

  it "generates keys" do
    described_class.generate.should be_a described_class
  end

  it "signs messages as bytes" do
    subject.sign(message).should eq signature_bytes
  end

  it "signs messages as hex", :pending => "api discussion" do
    subject.hexsign(message).should eq signature_hex
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq signing_key_bytes
  end

  it "serializes to hex", :pending => "api discussion" do
    subject.to_hex.should eq signing_key_hex
  end

  it "initializes from hex", :pending => "api discussion" do
    described_class.new(signing_key_hex).to_bytes.should eq signing_key_bytes
  end
end
