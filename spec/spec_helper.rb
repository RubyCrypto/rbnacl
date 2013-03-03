# encoding: binary
require 'rubygems'
require 'bundler/setup'
require 'rbnacl'
require 'shared/box'
require 'shared/authenticator'
require 'shared/key_equality'

def hex2bytes(hex)
  Crypto::Encoder[:hex].decode(hex)
end