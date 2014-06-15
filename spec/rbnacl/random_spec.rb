# encoding: binary
RSpec.describe RbNaCl::Random do
  it "produces random bytes" do
    expect(RbNaCl::Random.random_bytes(16).bytesize).to eq(16)
  end
  it "produces different random bytes" do
    expect(RbNaCl::Random.random_bytes(16)).not_to eq(RbNaCl::Random.random_bytes(16))
  end
end
