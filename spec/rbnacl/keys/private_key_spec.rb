require 'spec_helper'

describe Crypto::PrivateKey do
  let (:bobsk) { "]\xAB\b~bJ\x8AKy\xE1\x7F\x8B\x83\x80\x0E\xE6o;\xB1)&\x18\xB6\xFD\x1C/\x8B'\xFF\x88\xE0\xEB" } # from the nacl distribution
  let (:bobsk_hex) { Crypto::Encoder[:hex].encode(bobsk) } # from the nacl distribution
  let(:bobpk) { "\xDE\x9E\xDB}{}\xC1\xB4\xD3[a\xC2\xEC\xE457?\x83C\xC8[xgM\xAD\xFC~\x14o\x88+O" }
  let (:sk) { Crypto::PrivateKey.new(bobsk)  }
  let (:sk_hex) { Crypto::PrivateKey.new(bobsk_hex, :hex)  }

  context "generate" do
    let(:secret_key) { Crypto::PrivateKey.generate }

    it "returns a secret key" do
      secret_key.should be_a Crypto::PrivateKey
    end

    it "has the public key also set" do
      secret_key.public_key.should be_a Crypto::PublicKey
    end
  end

  context "new" do
    it "accepts a valid key" do
      expect { Crypto::PrivateKey.new(bobsk) }.not_to raise_error
    end
    it "accepts a hex encoded key" do
      expect { Crypto::PrivateKey.new(bobsk_hex, :hex) }.not_to raise_error
    end
    it "rejects a nil key" do
      expect { Crypto::PrivateKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PrivateKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "public_key" do
    it "returns a public key" do
      sk.public_key.should be_a Crypto::PublicKey
    end
    it "returns the correct public key" do
      sk.public_key.to_bytes.should eql bobpk
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      sk.to_bytes.should eq bobsk
    end

    it "returns the bytes of the key after being passed as hex" do
      sk_hex.to_bytes.should eq bobsk
    end
  end

  context "#to_s" do
    it "returns the bytes of the key hex encoded" do
      sk.to_s(:hex).should eq bobsk_hex
    end
    it "returns the raw bytes of the key" do
      sk.to_s.should eq bobsk
    end
  end

  include_examples "key equality" do
    let(:key) { sk }
    let(:key_bytes) { bobsk }
    let(:other_key) { described_class.new(bobpk) }
  end
end
