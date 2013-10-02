# encoding: binary
require 'spec_helper'

describe RbNaCl::OneTimeAuth do
  let(:tag) { vector :auth_onetime }

  include_examples "authenticator"
end
