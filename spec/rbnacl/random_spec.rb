# encoding: binary
describe RbNaCl::Random do
  it "produces random bytes" do
    RbNaCl::Random.random_bytes(16).bytesize.should == 16
  end
  it "produces different random bytes" do
    RbNaCl::Random.random_bytes(16).should_not == RbNaCl::Random.random_bytes(16)
  end
end
