# encoding: binary
require 'spec_helper'

describe Crypto::HMAC::SHA256 do
  let(:tag) { vector :auth_hmacsha256 }

  include_examples "authenticator"
end
