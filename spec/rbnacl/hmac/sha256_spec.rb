# encoding: binary
require 'spec_helper'

describe Crypto::HMAC::SHA256 do
  let(:hex_tag) { hex_vector :auth_hmacsha256 }

  include_examples "authenticator"
end
