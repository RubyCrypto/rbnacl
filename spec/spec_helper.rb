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

def bytes2hex(bytes)
  Crypto::Encoder[:hex].encode(bytes)
end

def test_vector(name)
  hex2bytes(hex_vector(name))
end

def hex_vector(name)
  Crypto::TestVectors[name]
end
