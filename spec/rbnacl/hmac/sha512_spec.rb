# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::HMAC::SHA512 do
  let(:tag) { vector :auth_hmacsha512 }

  include_examples "authenticator"
end
