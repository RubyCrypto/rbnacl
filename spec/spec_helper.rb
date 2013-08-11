# encoding: binary
require 'coveralls'
Coveralls.wear!

require 'bundler/setup'
require 'rbnacl'
require 'shared/box'
require 'shared/authenticator'
require 'shared/key_equality'

def vector(name)
  [Crypto::TestVectors[name]].pack("H*")
end
