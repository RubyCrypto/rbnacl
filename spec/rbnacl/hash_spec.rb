require 'spec_helper'

describe Crypto::Hash do
  context "sha256" do
    let(:reference_string) { "The quick brown fox jumps over the lazy dog." }
    let(:reference_string_hash) { "\xEFS\x7F%\xC8\x95\xBF\xA7\x82Re)\xA9\xB6=\x97\xAAc\x15d\xD5\xD7\x89\xC2\xB7eD\x8C\x865\xFBl" }
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
  end
end
