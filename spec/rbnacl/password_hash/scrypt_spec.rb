# encoding: binary
require 'spec_helper'

RSpec.describe RbNaCl::PasswordHash::SCrypt do
  let(:reference_password) { vector :scrypt_password }
  let(:reference_salt)     { vector :scrypt_salt }
  let(:reference_opslimit) { RbNaCl::TestVectors[:scrypt_opslimit] }
  let(:reference_memlimit) { RbNaCl::TestVectors[:scrypt_memlimit] }
  let(:reference_digest)   { vector :scrypt_digest }

  it "calculates the correct digest for a reference password/salt" do
    digest = RbNaCl::PasswordHash.scrypt(
      reference_password,
      reference_salt,
      reference_opslimit,
      reference_memlimit
    )

    expect(digest).to eq reference_digest
  end
end
