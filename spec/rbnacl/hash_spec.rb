# encoding: binary
require 'spec_helper'

describe Crypto::Hash do
  context "sha256" do
    let(:reference_string)          { test_vector :sha256_message }
    let(:reference_string_hash)     { test_vector :sha256_digest }
    let(:reference_string_hash_hex) { bytes2hex reference_string_hash }
    let(:empty_string_hash_hex)     { "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" }
    let(:empty_string_hash)         { hex2bytes empty_string_hash_hex }

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
    let(:reference_string)          { "The quick brown fox jumps over the lazy dog." }
    let(:reference_string_hash_hex) { "91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bbc6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed" }
    let(:empty_string_hash_hex)     { "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e" }
    let(:reference_string_hash)     { hex2bytes reference_string_hash_hex }
    let(:empty_string_hash)         { hex2bytes empty_string_hash_hex }

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

  if Crypto::NaCl.supported_version? :libsodium, '0.4.0'
    context "blake2b" do
      let(:reference_string)          { 'The quick brown fox jumps over the lazy dog' }
      let(:reference_string_hash_hex) { 'a8add4bdddfd93e4877d2746e62817b116364a1fa7bc148d95090bc7333b3673f82401cf7aa2e4cb1ecd90296e3f14cb5413f8ed77be73045b13914cdcd6a918' }
      let(:empty_string_hash_hex)     { '786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce' }
      let(:reference_string_hash)     { hex2bytes reference_string_hash_hex }
      let(:empty_string_hash)         { hex2bytes empty_string_hash_hex }

      it "calculates the correct hash for a reference string" do
        Crypto::Hash.blake2b(reference_string).should eq reference_string_hash
      end

      it "calculates the correct hash for an empty string" do
        Crypto::Hash.blake2b("").should eq empty_string_hash
      end
    end
  end
end
