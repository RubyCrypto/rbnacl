# encoding: binary
# frozen_string_literal: true

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

  context "arbitrary length message API" do
    let(:blake2b) { RbNaCl::Hash::Blake2b.new }

    it "calculates the correct hash for a reference string" do
      blake2b << reference_string
      expect(blake2b.digest).to eq reference_string_hash
    end

    it "calculates the correct hash for an empty string" do
      blake2b << ""
      expect(blake2b.digest).to eq empty_string_hash
    end

    it "raise CryptoError when digest called without reset / message" do
      expect { blake2b.digest }.to raise_error(RbNaCl::CryptoError)
    end

    it "calculates hash for empty string when digest called directly after reset" do
      blake2b.reset
      expect(blake2b.digest).to eq empty_string_hash
    end
  end

  context "keyed" do
    let(:reference_string)      { vector :blake2b_keyed_message }
    let(:reference_key)         { vector :blake2b_key }
    let(:reference_string_hash) { vector :blake2b_keyed_digest }

    it "calculates keyed hashes correctly" do
      expect(RbNaCl::Hash.blake2b(reference_string, key: reference_key)).to eq reference_string_hash
    end

    it "doesn't accept empty strings as a key" do
      expect { RbNaCl::Hash.blake2b(reference_string, key: "") }.to raise_error(RbNaCl::LengthError)
    end

    context "arbitrary length message API" do
      let(:blake2b)    { RbNaCl::Hash::Blake2b.new(key: "") }
      let(:blake2b_wk) { RbNaCl::Hash::Blake2b.new(key: reference_key) }

      it "calculates keyed hashes correctly" do
        blake2b_wk << reference_string
        expect(blake2b_wk.digest).to eq reference_string_hash
      end

      it "doesn't accept empty strings as a key" do
        expect do
          blake2b << reference_string
          blake2b.digest
        end.to raise_error(RbNaCl::LengthError)
      end
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

    context "arbitrary length message API" do
      let(:blake2b)    { RbNaCl::Hash::Blake2b.new(personal: reference_personal) }
      let(:blake2b_sh) { RbNaCl::Hash::Blake2b.new(personal: reference_personal_short) }

      it "calculates personalised hashes correctly" do
        blake2b << reference_string
        expect(blake2b.digest).to eq reference_personal_hash
      end

      it "calculates personalised hashes correctly with a short personal" do
        blake2b_sh << reference_string
        expect(blake2b_sh.digest).to eq reference_personal_short_hash
      end
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

    context "arbitrary length message API" do
      let(:blake2b)    { RbNaCl::Hash::Blake2b.new(salt: reference_salt) }
      let(:blake2b_sh) { RbNaCl::Hash::Blake2b.new(salt: reference_salt_short) }

      it "calculates saltised hashes correctly" do
        blake2b << reference_string
        expect(blake2b.digest).to eq reference_salt_hash
      end

      it "calculates saltised hashes correctly with a short salt" do
        blake2b_sh << reference_string
        expect(blake2b_sh.digest).to eq reference_salt_short_hash
      end
    end
  end
end
