# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::HMAC::SHA512256 do
  let(:tag) { vector :auth_hmacsha512256 }

  include_examples "authenticator"
end
