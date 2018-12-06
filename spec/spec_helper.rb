# encoding: binary
# frozen_string_literal: true

require "json"
require "coveralls"
Coveralls.wear!

# Run the specs prior to running the self-test
$RBNACL_SELF_TEST = false

require "bundler/setup"
require "rbnacl"

require "shared/box"
require "shared/sealed_box"
require "shared/authenticator"
require "shared/key_equality"
require "shared/serializable"
require "shared/aead"
require "shared/hmac"

def vector(name)
  [RbNaCl::TEST_VECTORS[name]].pack("H*")
end

RSpec.configure do |config|
  config.after :all do
    # Run the self-test after all the specs have passed
    require "rbnacl/self_test"
  end

  config.disable_monkey_patching!
end
