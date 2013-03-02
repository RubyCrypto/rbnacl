# encoding: binary
require 'spec_helper'

describe Crypto::Auth::OneTime do
  let(:hex_tag) { Crypto::TestVectors[:auth_onetime] }

  include_examples "authenticator"
end
