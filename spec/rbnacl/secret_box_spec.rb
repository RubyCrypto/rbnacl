# encoding: binary
require 'spec_helper'

describe Crypto::SecretBox do
  let (:key) { test_vector :secret_key }

  context "new" do
    it "accepts strings" do
      expect { Crypto::SecretBox.new(key) }.to_not raise_error(Exception)
    end

    it "raises on a nil key" do
      expect { Crypto::SecretBox.new(nil) }.to raise_error(Crypto::LengthError, "Secret key was nil \(Expected #{Crypto::NaCl::SECRETKEYBYTES}\)")
    end

    it "raises on a short key" do
      expect { Crypto::SecretBox.new("hello") }.to raise_error(Crypto::LengthError, "Secret key was 5 bytes \(Expected #{Crypto::NaCl::SECRETKEYBYTES}\)")
    end
  end

  include_examples "box" do
    let(:box) { Crypto::SecretBox.new(key) }
  end
end
