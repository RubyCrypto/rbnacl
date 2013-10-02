# encoding: binary
require 'spec_helper'

describe RbNaCl::GroupElement do
  let(:alice_private)  { vector :alice_private }
  let(:alice_public)   { vector :alice_public }

  let(:bob_public)     { vector :bob_public }

  let(:alice_mult_bob) { vector :alice_mult_bob }

  subject { described_class.new(bob_public) }

  it "multiplies integers with the base point" do
    described_class.base.mult(alice_private).to_s.should eq alice_public
  end

  it "multiplies integers with arbitrary points" do
    described_class.new(bob_public).mult(alice_private).to_s.should eq alice_mult_bob
  end

  it "serializes to bytes" do
    subject.to_bytes.should eq bob_public
  end

  include_examples "serializable"
end
