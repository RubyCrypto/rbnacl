# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::HMAC::SHA512 do
  let(:key)       { vector :auth_hmac_key }
  let(:message)   { vector :auth_hmac_data }
  let(:tag)       { vector :auth_hmacsha512_tag }
  let(:mult_tag)  { vector :auth_hmacsha512_mult_tag }
  let(:wrong_key) { "key".encode("utf-8") }

  include_examples "HMAC"
  include_examples "authenticator"
end
