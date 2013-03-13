# encoding: binary
require 'spec_helper'

describe Crypto::Ciphertext do
  let(:text) { "hello" }
  let(:primitive) { :test  }
  let(:ciphertext) { described_class.new(text, primitive) }
  let(:encoded_ciphertext) { described_class.new(text, primitive, :hex) }
  it "returns the ciphertext on #to_s" do
    ciphertext.to_s.should == text
  end

  it "returns the primitive" do
    ciphertext.primitive.should be primitive
  end

  it "interpolates correctly" do
    "#{ciphertext}".should == text
  end

  it "packs correctly" do
    [ciphertext].pack('a*').should == text
  end

  it "encodes when asked" do
    ciphertext.to_s(:hex).should == Crypto::Encoder[:hex].encode(text)
  end

  it "behaves like a string for equality" do
    ciphertext.should == text
  end

  it "behaves like a string for addition" do
    (ciphertext + text).should == text * 2
  end
  
  it "behaves like a string for addition" do
    (text + ciphertext).should == text * 2
  end

  it "accepts a default encoding" do
    encoded_ciphertext.should == Crypto::Encoder[:hex].encode(text)
  end
end
