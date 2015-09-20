# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::Hash::Blake2b do
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

  context "personalized" do
    let(:reference_string)              { vector :blake2b_message }
    let(:reference_personal)            { vector :blake2b_personal }
    let(:reference_personal_hash)       { vector :blake2b_personal_digest }
    let(:reference_personal_short)      { vector :blake2b_personal_short }
    let(:reference_personal_short_hash) { vector :blake2b_personal_short_digest }

    it "calculates personalised hashes correctly" do
      expect(RbNaCl::Hash.blake2b(reference_string, personal: reference_personal)).to eq reference_personal_hash
    end

    it "calculates personalised hashes correctly with a short personal" do
      expect(RbNaCl::Hash.blake2b(reference_string, personal: reference_personal_short)).to eq reference_personal_short_hash
    end
  end

  context "salted" do
    let(:reference_string)          { vector :blake2b_message }
    let(:reference_salt)            { vector :blake2b_salt }
    let(:reference_salt_hash)       { vector :blake2b_salt_digest }
    let(:reference_salt_short)      { vector :blake2b_salt_short }
    let(:reference_salt_short_hash) { vector :blake2b_salt_short_digest }

    it "calculates saltised hashes correctly" do
      expect(RbNaCl::Hash.blake2b(reference_string, salt: reference_salt)).to eq reference_salt_hash
    end

    it "calculates saltised hashes correctly with a short salt" do
      expect(RbNaCl::Hash.blake2b(reference_string, salt: reference_salt_short)).to eq reference_salt_short_hash
    end
  end
end
