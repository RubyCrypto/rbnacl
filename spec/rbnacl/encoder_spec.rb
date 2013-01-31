require 'spec_helper'

describe Crypto::Encoder do
  it "registers encoders" do
    expect { Crypto::Encoder[:foobar] }.to raise_exception(ArgumentError)

    class FoobarEncoder < described_class
      register :foobar
    end

    Crypto::Encoder[:foobar].should be_a FoobarEncoder
  end
end