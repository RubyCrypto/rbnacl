# encoding: binary
require 'spec_helper'

describe Crypto::Auth::OneTime do
  let(:tag) { vector :auth_onetime }

  include_examples "authenticator"
end
