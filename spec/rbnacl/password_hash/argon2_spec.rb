# encoding: binary
# frozen_string_literal: true

if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
  RSpec.describe RbNaCl::PasswordHash::Argon2 do
    let(:reference_password) { vector :argon2_password }
    let(:reference_salt)     { vector :argon2_salt }
    let(:reference_opslimit) { RbNaCl::TEST_VECTORS[:argon2_opslimit] }
    let(:reference_memlimit) { RbNaCl::TEST_VECTORS[:argon2_memlimit] }
    let(:reference_digest)   { vector :argon2_digest }
    let(:reference_outlen)   { RbNaCl::TEST_VECTORS[:argon2_outlen] }

    let(:str_ref_password) { RbNaCl::TEST_VECTORS[:argon2_str_passwd] }
    let(:str_ref_digest)   { RbNaCl::TEST_VECTORS[:argon2_str_digest] }

    it "calculates the correct digest for a reference password/salt" do
      digest = RbNaCl::PasswordHash.argon2(
        reference_password,
        reference_salt,
        reference_opslimit,
        reference_memlimit,
        reference_outlen
      )

      expect(digest).to eq reference_digest
    end

    it "verifies password" do
      valid = RbNaCl::PasswordHash.argon2_valid?(str_ref_password, str_ref_digest)
      expect(valid).to eq true
    end

    it "creates digest string" do
      digest = RbNaCl::PasswordHash.argon2_str(str_ref_password)
      valid = RbNaCl::PasswordHash.argon2_valid?(str_ref_password, digest)
      expect(valid).to eq true
    end

    it "fails on invalid passwords" do
      valid = RbNaCl::PasswordHash.argon2_valid?("wrongpassword", str_ref_digest)
      expect(valid).to eq false
    end
  end
end
