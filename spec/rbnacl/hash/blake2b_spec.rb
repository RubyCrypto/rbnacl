# encoding: binary
require 'spec_helper'

if RbNaCl::NaCl.supported_version? :libsodium, '0.4.0'
  describe RbNaCl::Hash::Blake2b do
    let(:reference_string)      { vector :blake2b_message }
    let(:reference_string_hash) { vector :blake2b_digest }
    let(:empty_string_hash)     { vector :blake2b_empty }

    it "calculates the correct hash for a reference string" do
      RbNaCl::Hash.blake2b(reference_string).should eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      RbNaCl::Hash.blake2b("").should eq empty_string_hash
    end

    context "keyed" do
      let(:reference_string)      { vector :blake2b_keyed_message }
      let(:reference_key)         { vector :blake2b_key }
      let(:reference_string_hash) { vector :blake2b_keyed_digest }

      it "calculates keyed hashes correctly" do
        RbNaCl::Hash.blake2b(reference_string, :key => reference_key).should eq reference_string_hash
      end
    end
  end
end
