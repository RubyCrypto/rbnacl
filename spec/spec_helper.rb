# encoding: binary
require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
require 'rbnacl'
require 'shared/box'
require 'shared/authenticator'
require 'shared/key_equality'
require 'shared/serializable'

def vector(name)
  [RbNaCl::TestVectors[name]].pack("H*")
end
