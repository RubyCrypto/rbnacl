require 'spec_helper'

describe Crypto::Box do
  let (:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj"  } # from the nacl distribution
  let (:bobsk) { "]\xAB\b~bJ\x8AKy\xE1\x7F\x8B\x83\x80\x0E\xE6o;\xB1)&\x18\xB6\xFD\x1C/\x8B'\xFF\x88\xE0\xEB" } # from the nacl distribution
  let (:alice_key) { Crypto::PublicKey.new(alicepk) }
  let (:bob_key) { Crypto::PrivateKey.new(bobsk) }

  context "new" do
    it "accepts strings" do
      expect { Crypto::Box.new(alicepk, bobsk) }.to_not raise_error(Exception)
    end

    it "accepts KeyPairs" do
      expect { Crypto::Box.new(alice_key, bob_key) }.to_not raise_error(Exception)
    end

    it "raises on a nil public key" do
      expect { Crypto::Box.new(nil, bobsk) }.to raise_error(ArgumentError, /Must provide a valid public key/)
    end

    it "raises on an invalid public key" do
      expect { Crypto::Box.new("hello", bobsk) }.to raise_error(ArgumentError, /Must provide a valid public key/)
    end

    it "raises on a nil secret key" do
      expect { Crypto::Box.new(alicepk, nil) }.to raise_error(ArgumentError, /Must provide a valid private key/)
    end

    it "raises on an invalid secret key" do
      expect { Crypto::Box.new(alicepk, "hello") }.to raise_error(ArgumentError, /Must provide a valid private key/)
    end
  end


  include_examples 'box' do
    let(:box) { Crypto::Box.new(alicepk, bobsk) }
  end
end
