require 'spec_helper'

describe Crypto::KeyPair do
  context "generate" do

    it "returns a keypair" do
      Crypto::KeyPair.generate.should be_a Crypto::KeyPair
    end
  end

  let (:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj"  } # from the nacl distribution
  let (:bobsk) { "]\xAB\b~bJ\x8AKy\xE1\x7F\x8B\x83\x80\x0E\xE6o;\xB1)&\x18\xB6\xFD\x1C/\x8B'\xFF\x88\xE0\xEB" } # from the nacl distribution

  context "valid_pk?" do
    it "doesn't pass nil" do
      Crypto::KeyPair.valid_pk?(nil).should be false
    end
    it "doesn't pass a short string" do
      Crypto::KeyPair.valid_pk?("hello").should be false
    end
    it "does pass a valid key" do
      Crypto::KeyPair.valid_pk?(alicepk).should be true
    end
  end

  context "valid_pk?" do
    it "doesn't pass nil" do
      Crypto::KeyPair.valid_sk?(nil).should be false
    end
    it "doesn't pass a short string" do
      Crypto::KeyPair.valid_sk?("hello").should be false
    end
    it "does pass a valid key" do
      Crypto::KeyPair.valid_sk?(bobsk).should be true
    end
  end

  context "public?" do
    let (:keypair) { Crypto::KeyPair.new(alicepk) }
    let (:invalid_pair) { Crypto::KeyPair.new("") }

    it "returns true for a valid keypair" do
      keypair.public?.should be true
    end

    it "returns false for an invalid keypair" do
      invalid_pair.public?.should be false
    end
  end

  context "secret?" do
    let (:keypair) { Crypto::KeyPair.new(alicepk, bobsk) }
    let (:invalid_pair) { Crypto::KeyPair.new(alicepk, "") }

    it "returns true for a valid keypair" do
      keypair.secret?.should be true
    end

    it "returns false for an invalid keypair" do
      invalid_pair.secret?.should be false
    end

  end
end
