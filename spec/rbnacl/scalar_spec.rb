require 'spec_helper'

describe Crypto::Scalar do
  let (:alicesk) { "w\am\ns\x18\xA5}<\x16\xC1rQ\xB2fE\xDFL/\x87\xEB\xC0\x99*\xB1w\xFB\xA5\x1D\xB9,*" } # from the nacl distribution
  let (:alicepk) { "\x85 \xF0\t\x890\xA7Tt\x8B}\xDC\xB4>\xF7Z\r\xBF:\r&8\x1A\xF4\xEB\xA4\xA9\x8E\xAA\x9BNj" } # from the nacl distribution
  subject { Crypto::Scalar.new(alicesk) }

  it "multiplies with a standard group element" do
    subject.mult_base.should == alicepk
  end
end
