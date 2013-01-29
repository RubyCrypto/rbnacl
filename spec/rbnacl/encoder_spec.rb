require 'spec_helper'

describe Crypto::Encoder do
  it "registers encoders" do
    Crypto::Encoder[:foobar].should be_nil

    class FoobarEncoder < described_class
      register :foobar
    end

    Crypto::Encoder[:foobar].should be_a FoobarEncoder
  end
end