# encoding: binary
# frozen_string_literal: true

if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
  RSpec.describe RbNaCl::PasswordHash::Argon2 do
    let(:argon2i_password) { vector :argon2i_password }
    let(:argon2i_salt)     { vector :argon2i_salt }
    let(:argon2i_opslimit) { RbNaCl::TEST_VECTORS[:argon2i_opslimit] }
    let(:argon2i_memlimit) { RbNaCl::TEST_VECTORS[:argon2i_memlimit] }
    let(:argon2i_digest)   { vector :argon2i_digest }
    let(:argon2i_outlen)   { RbNaCl::TEST_VECTORS[:argon2i_outlen] }

    let(:argon2id_password) { vector :argon2id_password }
    let(:argon2id_salt)     { vector :argon2id_salt }
    let(:argon2id_opslimit) { RbNaCl::TEST_VECTORS[:argon2id_opslimit] }
    let(:argon2id_memlimit) { RbNaCl::TEST_VECTORS[:argon2id_memlimit] }
    let(:argon2id_digest)   { vector :argon2id_digest }
    let(:argon2id_outlen)   { RbNaCl::TEST_VECTORS[:argon2id_outlen] }

    let(:str_ref_password) { RbNaCl::TEST_VECTORS[:argon2_str_passwd] }
    let(:str_ref_digest)   { RbNaCl::TEST_VECTORS[:argon2_str_digest] }

    it "calculates the correct argon2i digest for a reference password/salt" do
      digest = RbNaCl::PasswordHash.argon2i(
        argon2i_password,
        argon2i_salt,
        argon2i_opslimit,
        argon2i_memlimit,
        argon2i_outlen
      )
      expect(digest).to eq argon2i_digest
    end

    if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
      it "calculates the correct argon2id digest for a reference password/salt" do
        digest = RbNaCl::PasswordHash.argon2id(
          argon2id_password,
          argon2id_salt,
          argon2id_opslimit,
          argon2id_memlimit,
          argon2id_outlen
        )
        expect(digest).to eq argon2id_digest
      end

      it "calculates the correct argon2 default digest" do
        if RbNaCl::Sodium::Version.supported_version?("1.0.15")
          digest = RbNaCl::PasswordHash.argon2(
            argon2id_password,
            argon2id_salt,
            argon2id_opslimit,
            argon2id_memlimit,
            argon2id_outlen
          )
          expect(digest).to eq argon2id_digest
        else
          digest = RbNaCl::PasswordHash.argon2(
            argon2i_password,
            argon2i_salt,
            argon2i_opslimit,
            argon2i_memlimit,
            argon2i_outlen
          )
          expect(digest).to eq argon2i_digest
        end
      end

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
