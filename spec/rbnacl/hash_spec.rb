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

      context "keyed" do
        let(:reference_string_hex)      { "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfe" }
        let(:reference_string)          { hex2bytes reference_string_hex }
        let(:reference_string_hash_hex) { "142709d62e28fcccd0af97fad0f8465b971e82201dc51070faa0372aa43e92484be1c1e73ba10906d5d1853db6a4106e0a7bf9800d373d6dee2d46d62ef2a461" }
        let(:reference_string_hash)     { hex2bytes reference_string_hash_hex }
        let(:reference_key_hex)         { "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f" }
        let(:reference_key)             { hex2bytes reference_key_hex }

        it "calculates keyed hashes correctly" do
          Crypto::Hash.blake2b(reference_string, :key => reference_key).should eq reference_string_hash
        end
      end
    end
  end
end
