# encoding: binary
require 'spec_helper'

describe Crypto::Auth::OneTime do
  let(:hex_tag) { hex_vector :auth_onetime }

  include_examples "authenticator"
end
