require 'spec_helper'

describe Crypto::PrivateKey do
  let (:bobsk) { "]\xAB\b~bJ\x8AKy\xE1\x7F\x8B\x83\x80\x0E\xE6o;\xB1)&\x18\xB6\xFD\x1C/\x8B'\xFF\x88\xE0\xEB" } # from the nacl distribution
  let (:sk) { Crypto::PrivateKey.new(bobsk)  }
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
      expect { Crypto::PrivateKey.new(bobsk) }.not_to raise_error(ArgumentError)
    end
    it "rejects a nil key" do
      expect { Crypto::PrivateKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PrivateKey.new("short") }.to raise_error(ArgumentError)
    end
  end


  context "valid?" do
    it "doesn't pass nil" do
      Crypto::PrivateKey.valid?(nil).should be false
    end
    it "doesn't pass a short string" do
      Crypto::PrivateKey.valid?("hello").should be false
    end
    it "does pass a valid key" do
      Crypto::PrivateKey.valid?(bobsk).should be true
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      sk.to_bytes.should eq bobsk
    end
  end

  context "#to_hex" do
    it "returns the bytes of the key hex encoded" do
      sk.to_hex.should eq bobsk.unpack('H*').first
    end
  end
end

describe Crypto::PublicKey do
  let (:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj"  } # from the nacl distribution
  let (:pk) { Crypto::PublicKey.new(alicepk) }
  context "new" do
    it "accepts a valid key" do
      expect { Crypto::PublicKey.new(alicepk) }.not_to raise_error(ArgumentError)
    end
    it "rejects a nil key" do
      expect { Crypto::PublicKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PublicKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "valid?" do
    it "doesn't pass nil" do
      Crypto::PublicKey.valid?(nil).should be false
    end
    it "doesn't pass a short string" do
      Crypto::PublicKey.valid?("hello").should be false
    end
    it "does pass a valid key" do
      Crypto::PublicKey.valid?(alicepk).should be true
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      pk.to_bytes.should eq alicepk
    end
  end

  context "#to_hex" do
    it "returns the bytes of the key hex encoded" do
      pk.to_hex.should eq alicepk.unpack('H*').first
    end
  end
end

