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

  # Setting this config option `false` removes rspec-core's monkey patching of the
  # top level methods like `describe`, `shared_examples_for` and `shared_context`
  # on `main` and `Module`. The methods are always available through the `RSpec`
  # module like `RSpec.describe` regardless of this setting.
  # For backwards compatibility this defaults to `true`.
  #
  # https://relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/global-namespace-dsl
  config.expose_dsl_globally = false
end
