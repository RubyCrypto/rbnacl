# encoding: binary
require 'spec_helper'

describe Crypto::HMAC::SHA512256 do
  let(:hex_tag) { hex_vector :auth_hmacsha512256 }

  include_examples "authenticator"
end
