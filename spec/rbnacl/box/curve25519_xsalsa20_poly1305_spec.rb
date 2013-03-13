# encoding: binary
require 'spec_helper'

describe Crypto::Box::Curve25519XSalsa20Poly1305 do
  let(:alicepk_hex) { Crypto::TestVectors[:alice_public] }
  let(:bobsk_hex)   { Crypto::TestVectors[:bob_private] }

  let(:alicepk)   { hex2bytes(alicepk_hex) }
  let(:bobsk)     { hex2bytes(bobsk_hex) }
  let(:alice_key) { Crypto::PublicKey.new(alicepk) }
  let(:bob_key)   { Crypto::PrivateKey.new(bobsk) }

  context "new" do
    it "accepts strings" do
      expect { described_class.new(alicepk, bobsk) }.to_not raise_error(Exception)
    end

    it "accepts KeyPairs" do
      expect { described_class.new(alice_key, bob_key) }.to_not raise_error(Exception)
    end

    it "raises on a nil public key" do
      expect { described_class.new(nil, bobsk) }.to raise_error(Crypto::LengthError, /Public key was nil \(Expected 32\)/)
    end

    it "raises on an invalid public key" do
      expect { described_class.new("hello", bobsk) }.to raise_error(Crypto::LengthError, /Public key was 5 bytes \(Expected 32\)/)
    end

    it "raises on a nil secret key" do
      expect { described_class.new(alicepk, nil) }.to raise_error(Crypto::LengthError, /Private key was nil \(Expected 32\)/)
    end

    it "raises on an invalid secret key" do
      expect { described_class.new(alicepk, "hello") }.to raise_error(Crypto::LengthError, /Private key was 5 bytes \(Expected 32\)/)
    end
  end

  include_examples 'box' do
    let(:box) { described_class.new(alicepk, bobsk) }
  end
end
