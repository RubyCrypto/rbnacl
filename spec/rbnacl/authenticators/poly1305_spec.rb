# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::OneTimeAuth do
  let(:key)     { vector "auth_key_#{described_class.key_bytes}".to_sym }
  let(:message) { vector :auth_message }
  let(:tag)     { vector :auth_onetime }

  context ".new" do
    it "raises ArgumentError on a key which is too long" do
      expect { described_class.new("\0" * described_class.key_bytes.succ) }.to raise_error(ArgumentError)
    end
  end

  context ".auth" do
    it "raises ArgumentError on a key which is too long" do
      expect { described_class.auth("\0" * described_class.key_bytes.succ, message) }.to raise_error(ArgumentError)
    end
  end

  context ".verify" do
    it "raises ArgumentError on a key which is too long" do
      expect { described_class.verify("\0" * described_class.key_bytes.succ, tag, message) }.to raise_error(ArgumentError)
    end
  end

  include_examples "authenticator"
end
