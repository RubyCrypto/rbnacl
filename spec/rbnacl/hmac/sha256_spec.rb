# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::HMAC::SHA256 do
  let(:tag) { vector :auth_hmacsha256 }

  include_examples "authenticator"
end
