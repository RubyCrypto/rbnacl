require 'spec_helper'

describe Crypto, 'random_bytes' do
  let(:length) { 42 } # chosen by fair dice roll, guaranteed to be random

  it "generates the requested number of random bytes" do
    bytes = Crypto.random_bytes(length)
    bytes.should be_a String
    bytes.length.should eq length
  end
end
