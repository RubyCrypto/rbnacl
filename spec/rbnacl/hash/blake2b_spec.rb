# encoding: binary
require 'spec_helper'

describe RbNaCl::Hash::Blake2b do
  let(:reference_string)      { vector :blake2b_message }
  let(:reference_string_hash) { vector :blake2b_digest }
  let(:empty_string_hash)     { vector :blake2b_empty }

  it "calculates the correct hash for a reference string" do
    expect(RbNaCl::Hash.blake2b(reference_string)).to eq reference_string_hash
  end

  it "calculates the correct hash for an empty string" do
    expect(RbNaCl::Hash.blake2b("")).to eq empty_string_hash
  end

  context "keyed" do
    let(:reference_string)      { vector :blake2b_keyed_message }
    let(:reference_key)         { vector :blake2b_key }
    let(:reference_string_hash) { vector :blake2b_keyed_digest }

    it "calculates keyed hashes correctly" do
      expect(RbNaCl::Hash.blake2b(reference_string, key: reference_key)).to eq reference_string_hash
    end

    it "doesn't accept empty strings as a key" do
      expect { RbNaCl::Hash.blake2b(reference_string, key: "") }.to raise_exception
    end
  end
end
