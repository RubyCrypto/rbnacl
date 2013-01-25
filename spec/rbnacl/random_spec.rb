#!/usr/bin/env ruby
describe Crypto::Random do
  it "produces random bytes" do
    Crypto::Random.random_bytes(16).bytesize.should == 16
  end
  it "produces different random bytes" do
    Crypto::Random.random_bytes(16).should_not == Crypto::Random.random_bytes(16)
  end
end
