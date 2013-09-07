# encoding: binary
require 'spec_helper'

describe RbNaCl::Hash do
  context "sha256" do
    let(:reference_string)      { vector :sha256_message }
    let(:reference_string_hash) { vector :sha256_digest }
    let(:empty_string_hash)     { vector :sha256_empty }

    it "calculates the correct hash for a reference string" do
      RbNaCl::Hash.sha256(reference_string).should eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      RbNaCl::Hash.sha256("").should eq empty_string_hash
    end

    it "doesn't raise on a null byte" do
      expect { RbNaCl::Hash.sha256("\0") }.to_not raise_error(/ArgumentError: string contains null byte/)
    end
  end

  context "sha512" do
    let(:reference_string)      { vector :sha512_message }
    let(:reference_string_hash) { vector :sha512_digest }
    let(:empty_string_hash)     { vector :sha512_empty }

    it "calculates the correct hash for a reference string" do
      RbNaCl::Hash.sha512(reference_string).should eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      RbNaCl::Hash.sha512("").should eq empty_string_hash
    end

    it "doesn't raise on a null byte" do
      expect { RbNaCl::Hash.sha512("\0") }.to_not raise_error(/ArgumentError: string contains null byte/)
    end
  end

  if RbNaCl::NaCl.supported_version? :libsodium, '0.4.0'
    context "blake2b" do
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
end
