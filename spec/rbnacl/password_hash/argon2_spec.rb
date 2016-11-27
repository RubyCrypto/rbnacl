# encoding: binary
require "spec_helper"

if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
  RSpec.describe RbNaCl::PasswordHash::Argon2 do
    let(:reference_password) { vector :argon2_password }
    let(:reference_salt)     { vector :argon2_salt }
    let(:reference_opslimit) { RbNaCl::TEST_VECTORS[:argon2_opslimit] }
    let(:reference_memlimit) { RbNaCl::TEST_VECTORS[:argon2_memlimit] }
    let(:reference_digest)   { vector :argon2_digest }
    let(:reference_outlen)   { RbNaCl::TEST_VECTORS[:argon2_outlen] }

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
  end
end