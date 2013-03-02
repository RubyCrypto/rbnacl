# encoding: binary
require 'spec_helper'

describe Crypto::Encoders::Base64 do
  let(:source) { "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789" }
  let(:base64) { "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXowMTIzNDU2Nzg5" }

  it "encodes to base64" do
    subject.encode(source).should eq base64
  end

  it "decodes from base64" do
    subject.decode(base64).should eq source
  end
end
