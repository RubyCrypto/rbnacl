# encoding: binary
require 'spec_helper'

describe Crypto::SecretBox do
  let (:key) { vector :secret_key }

  context "new" do
    it "accepts strings" do
      expect { Crypto::SecretBox.new(key) }.to_not raise_error(Exception)
    end

    it "raises on a nil key" do
      expect { Crypto::SecretBox.new(nil) }.to raise_error(NoMethodError)
      pending "is a failed #to_s (NoMethodError) here sufficient?"
    end

    it "raises on a short key" do
      expect { Crypto::SecretBox.new("hello") }.to raise_error(Crypto::LengthError, "Secret key was 5 bytes \(Expected #{Crypto::NaCl::SECRETKEYBYTES}\)")
    end
  end

  include_examples "box" do
    let(:box) { Crypto::SecretBox.new(key) }
  end
end
