require 'spec_helper'

describe Crypto::PublicKey do
  let (:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj"  } # from the nacl distribution
  let (:alicepk_hex) { Crypto::Encoder[:hex].encode(alicepk)  }
  let (:pk) { Crypto::PublicKey.new(alicepk) }
  let (:pk_hex) { Crypto::PublicKey.new(alicepk_hex, :hex) }
  context "new" do
    it "accepts a valid key" do
      expect { Crypto::PublicKey.new(alicepk) }.not_to raise_error
    end
    it "accepts a valid key in hex" do
      expect { Crypto::PublicKey.new(alicepk_hex, :hex) }.not_to raise_error
    end
    it "rejects a nil key" do
      expect { Crypto::PublicKey.new(nil) }.to raise_error(ArgumentError)
    end
    it "rejects a short key" do
      expect { Crypto::PublicKey.new("short") }.to raise_error(ArgumentError)
    end
  end

  context "#to_bytes" do
    it "returns the bytes of the key" do
      pk.to_bytes.should eq alicepk
    end
    it "returns the bytes of the key" do
      pk_hex.to_bytes.should eq alicepk
    end
  end

  context "#to_s" do
    it "returns the bytes of the key" do
      pk.to_s.should eq alicepk
    end
    it "returns the bytes of the key hex encoded" do
      pk.to_s(:hex).should eq alicepk_hex
    end
  end
  
  include_examples "key equality" do
    let(:key) { pk }
    let(:key_bytes) { alicepk }
    let(:other_key) { described_class.new(alicepk.succ) }
  end
end
