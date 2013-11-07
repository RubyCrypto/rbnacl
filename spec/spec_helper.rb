# encoding: binary
require 'json'
require 'coveralls'
Coveralls.wear!

# Run the specs prior to running the self-test
$RBNACL_SELF_TEST = false

require 'bundler/setup'
require 'rbnacl'
require 'shared/box'
require 'shared/authenticator'
require 'shared/key_equality'
require 'shared/serializable'

def vector(name)
  [RbNaCl::TestVectors[name]].pack("H*")
end

RSpec.configure do |config|
  config.after :all do
    # Run the self-test after all the specs have passed
    require 'rbnacl/self_test'
  end
end
