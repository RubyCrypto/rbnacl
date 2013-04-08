# encoding: binary
require 'spec_helper'

describe Crypto::Hash do
  context "sha256" do
    let(:reference_string)      { test_vector :sha256_message }
    let(:reference_string_hash) { test_vector :sha256_digest }
    let(:empty_string_hash) { "\xE3\xB0\xC4B\x98\xFC\x1C\x14\x9A\xFB\xF4\xC8\x99o\xB9$'\xAEA\xE4d\x9B\x93L\xA4\x95\x99\exR\xB8U" }
    let(:reference_string_hash_hex) { reference_string_hash.unpack('H*').first }
    let(:empty_string_hash_hex) { empty_string_hash.unpack('H*').first }

    it "calculates the correct hash for a reference string" do
      Crypto::Hash.sha256(reference_string).should eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      Crypto::Hash.sha256("").should eq empty_string_hash
    end

    it "calculates the correct hash for a reference string and returns it in hex" do
      Crypto::Hash.sha256(reference_string, :hex).should eq reference_string_hash_hex
    end

    it "calculates the correct hash for an empty string and returns it in hex" do
      Crypto::Hash.sha256("", :hex).should eq empty_string_hash_hex
    end

    it "doesn't raise on a null byte" do
      expect { Crypto::Hash.sha256("\0") }.to_not  raise_error(/ArgumentError: string contains null byte/)
    end
  end

  context "sha512" do
    let(:reference_string) { "The quick brown fox jumps over the lazy dog." }
    let(:reference_string_hash) { "\x91\xEA\x12E\xF2\rF\xAE\x9A\x03z\x98\x9FT\xF1\xF7\x90\xF0\xA4v\a\xEE\xB8\xA1M\x12\x89\f\xEAw\xA1\xBB\xC6\xC7\xED\x9C\xF2\x05\xE6{\x7F+\x8F\xD4\xC7\xDF\xD3\xA7\xA8a~E\xF3\xC4c\xD4\x81\xC7\xE5\x86\xC3\x9A\xC1\xED" }
    let(:empty_string_hash) { "\xCF\x83\xE15~\xEF\xB8\xBD\xF1T(P\xD6m\x80\a\xD6 \xE4\x05\vW\x15\xDC\x83\xF4\xA9!\xD3l\xE9\xCEG\xD0\xD1<]\x85\xF2\xB0\xFF\x83\x18\xD2\x87~\xEC/c\xB91\xBDGAz\x81\xA582z\xF9'\xDA>" }
    let(:reference_string_hash_hex) { reference_string_hash.unpack('H*').first }
    let(:empty_string_hash_hex) { empty_string_hash.unpack('H*').first }

    it "calculates the correct hash for a reference string" do
      Crypto::Hash.sha512(reference_string).should eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      Crypto::Hash.sha512("").should eq empty_string_hash
    end

    it "calculates the correct hash for a reference string and returns it in hex" do
      Crypto::Hash.sha512(reference_string, :hex).should eq reference_string_hash_hex
    end

    it "calculates the correct hash for an empty string and returns it in hex" do
      Crypto::Hash.sha512("", :hex).should eq empty_string_hash_hex
    end

    it "doesn't raise on a null byte" do
      expect { Crypto::Hash.sha512("\0") }.to_not  raise_error(/ArgumentError: string contains null byte/)
    end
  end
end
