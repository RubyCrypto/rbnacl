require 'spec_helper'

describe Crypto::Encoders::Hex do
  let (:bytes) { [0xDE,0xAD,0xBE,0xEF].pack('c*') }
  let (:hex)   { "deadbeef" }

  it "encodes to hex" do
    subject.encode(bytes).should eq hex
  end

  it "decodes from hex" do
    subject.decode(hex).should eq bytes
  end
end
