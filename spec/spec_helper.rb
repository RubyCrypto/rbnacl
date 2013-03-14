# encoding: binary
require 'rubygems'
require 'bundler/setup'
require 'rbnacl'
require 'shared/box'
require 'shared/authenticator'
require 'shared/key_equality'
require 'coveralls'

Coveralls.wear!

def hex2bytes(hex)
  Crypto::Encoder[:hex].decode(hex)
end

def test_vector(name)
  hex2bytes(Crypto::TestVectors[name])
end
