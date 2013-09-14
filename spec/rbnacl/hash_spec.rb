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
end
