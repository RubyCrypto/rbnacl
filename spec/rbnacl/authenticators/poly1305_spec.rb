# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::OneTimeAuth do
  let(:tag) { vector :auth_onetime }

  include_examples "authenticator"
end
