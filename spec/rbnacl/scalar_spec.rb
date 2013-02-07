require 'spec_helper'

describe Crypto::Scalar do
  # Test vectors taken from the NaCl distribution
  let(:alicesk) { "w\am\ns\x18\xA5}<\x16\xC1rQ\xB2fE\xDFL/\x87\xEB\xC0\x99*\xB1w\xFB\xA5\x1D\xB9,*" } 
  let(:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj" }

  let(:bobpk) { "\xDE\x9E\xDB}{}\xC1\xB4\xD3[a\xC2\xEC\xE457?\x83C\xC8[xgM\xAD\xFC~\x14o\x88+O" }

  let(:alicexbob) { "J]\x9D[\xA4\xCE-\xE1r\x8E;\xF4\x805\x0F%\xE0~!\xC9G\xD1\x9E3v\xF0\x9B<\x1E\x16\x17B" }

  it "multiplies group elements with integers" do
    described_class.mult(alicesk, bobpk).should eq alicexbob
  end

  it "multiplies with a standard group element" do
    described_class.mult_base(alicesk).should eq alicepk
  end
end
