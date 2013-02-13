require 'spec_helper'

describe Crypto::Point do
  # Test vectors taken from the NaCl distribution
  let(:alicesk) { "w\am\ns\x18\xA5}<\x16\xC1rQ\xB2fE\xDFL/\x87\xEB\xC0\x99*\xB1w\xFB\xA5\x1D\xB9,*" } 
  let(:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj" }

  let(:bobpk) { "\xDE\x9E\xDB}{}\xC1\xB4\xD3[a\xC2\xEC\xE457?\x83C\xC8[xgM\xAD\xFC~\x14o\x88+O" }

  let(:alicexbob) { "J]\x9D[\xA4\xCE-\xE1r\x8E;\xF4\x805\x0F%\xE0~!\xC9G\xD1\x9E3v\xF0\x9B<\x1E\x16\x17B" }

  # Use the NaCl standard group element as the base point
  subject { described_class.new(bobpk) }

  it "multiplies integers with the base point" do
    described_class.base.mult(alicesk).to_bytes.should eq alicepk
  end

  it "multiplies integers with arbitrary points" do
    described_class.new(bobpk).mult(alicesk).to_bytes.should eq alicexbob
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq bobpk
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq Crypto::Encoder[:hex].encode(bobpk)
  end
end