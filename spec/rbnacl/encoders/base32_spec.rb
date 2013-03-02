# encoding: binary
require 'spec_helper'
require 'rbnacl/encoders/base32'

describe Crypto::Encoders::Base32 do
  let(:source) { "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789" }
  let(:base32) { "mfrggzdfmztwq2lknnwg23tpobyxe43uov3ho6dzpiydcmrtgq2tmnzyhfqwey3emvtgo2djnjvwy3lon5yhc4ttor2xm53ypf5damjsgm2dknrxha4wcytdmrswmz3infvgw3dnnzxxa4lson2hk5txpb4xumbrgiztinjwg44ds===" }

  it "encodes to base32" do
    subject.encode(source).should eq base32
  end

  it "decodes from base32" do
    subject.decode(base32).should eq source
  end
end
