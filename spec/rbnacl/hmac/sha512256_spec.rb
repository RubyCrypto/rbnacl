require 'spec_helper'

describe Crypto::HMAC::SHA512256 do
  let(:hex_tag) { Crypto::TestVectors[:auth_hmacsha512256] }

  include_examples "authenticator"
end
