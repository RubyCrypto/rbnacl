require 'spec_helper'

describe Crypto::SecretBox::XSalsa20Poly1305 do
  
  let (:key) { hex2bytes(Crypto::TestVectors[:secret_key]) }

  context "new" do
    it "accepts strings" do
      expect { described_class.new(key) }.to_not raise_error(Exception)
    end

    it "raises on a nil key" do
      expect { described_class.new(nil) }.to raise_error(Crypto::LengthError, "Secret key was nil \(Expected #{Crypto::NaCl::XSALSA20_POLY1305_SECRETBOX_KEYBYTES}\)")
    end

    it "raises on a short key" do
      expect { described_class.new("hello") }.to raise_error(Crypto::LengthError, "Secret key was 5 bytes \(Expected #{Crypto::NaCl::XSALSA20_POLY1305_SECRETBOX_KEYBYTES}\)")
    end
  end

  include_examples "box" do
    let(:box) { described_class.new(key) }
  end
end
