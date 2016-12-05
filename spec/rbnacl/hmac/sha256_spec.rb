# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::HMAC::SHA256 do
  let(:tag) { vector :auth_hmacsha256 }

  include_examples "authenticator"
end
