# encoding: binary
require 'spec_helper'

describe Crypto::SecretBox do
  let (:key) { Crypto::TestVectors[:secret_key] }

  context "new" do
    it "accepts strings" do
      expect { Crypto::SecretBox.new(key, :hex) }.to_not raise_error(Exception)
    end

    it "raises on a nil key" do
      expect { Crypto::SecretBox.new(nil) }.to raise_error(Crypto::LengthError, "Secret key was nil \(Expected #{Crypto::NaCl::SecretBox::XSALSA20_POLY1305_KEYBYTES}\)")
    end

    it "raises on a short key" do
      expect { Crypto::SecretBox.new("hello") }.to raise_error(Crypto::LengthError, "Secret key was 5 bytes \(Expected #{Crypto::NaCl::SecretBox::XSALSA20_POLY1305_KEYBYTES}\)")
    end
  end

  include_examples "box" do
    let(:box) { Crypto::SecretBox.new(key, :hex) }
  end
end
