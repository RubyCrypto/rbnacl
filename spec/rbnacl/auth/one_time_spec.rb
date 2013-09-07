# encoding: binary
require 'spec_helper'

describe RbNaCl::Auth::OneTime do
  let(:tag) { vector :auth_onetime }

  include_examples "authenticator"
end
