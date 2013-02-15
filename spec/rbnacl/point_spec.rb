require 'spec_helper'

describe Crypto::Point do
  let(:alice_private)  { Crypto::TestVectors[:alice_private] }
  let(:alice_public)   { Crypto::TestVectors[:alice_public] }

  let(:bob_public)     { Crypto::TestVectors[:bob_public] }

  let(:alice_mult_bob) { Crypto::TestVectors[:alice_mult_bob] }

  subject { described_class.new(bob_public, :hex) }

  it "multiplies integers with the base point" do
    described_class.base.mult(alice_private, :hex).to_s(:hex).should eq alice_public
  end

  it "multiplies integers with arbitrary points" do
    described_class.new(bob_public, :hex).mult(alice_private, :hex).to_s(:hex).should eq alice_mult_bob
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq Crypto::Encoder[:hex].decode(bob_public)
  end

  it "serializes to hex" do
    subject.to_s(:hex).should eq bob_public
  end
end