# encoding: binary
require 'spec_helper'

describe RbNaCl::SecretBox do
  let (:key) { vector :secret_key }

  context "new" do
    it "accepts strings" do
      expect { RbNaCl::SecretBox.new(key) }.to_not raise_error(Exception)
    end

    it "raises on a nil key" do
      expect { RbNaCl::SecretBox.new(nil) }.to raise_error(TypeError)
    end

    it "raises on a short key" do
      expect { RbNaCl::SecretBox.new("hello") }.to raise_error(RbNaCl::LengthError, "Secret key was 5 bytes \(Expected #{RbNaCl::SecretBox::KEYBYTES}\)")
    end
  end

  include_examples "box" do
    let(:box) { RbNaCl::SecretBox.new(key) }
  end
end
