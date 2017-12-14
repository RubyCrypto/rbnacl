# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::HMAC::SHA256 do
  let(:key)       { vector :auth_hmac_key }
  let(:message)   { vector :auth_hmac_data }
  let(:tag)       { vector :auth_hmacsha256_tag }
  let(:wrong_key) { "key".encode("utf-8") }

  context ".new" do
    it "raises EncodingError on a key with wrong encoding" do
      expect { described_class.new(wrong_key) }.to raise_error(EncodingError)
    end
  end

  context ".auth" do
    it "raises EncodingError on a key with wrong encoding " do
      expect { described_class.auth(wrong_key, message) }.to raise_error(EncodingError)
    end
  end

  context ".verify" do
    it "raises EncodingError on a key with wrong encoding" do
      expect { described_class.verify(wrong_key, tag, message) }.to raise_error(EncodingError)
    end
  end

  include_examples "authenticator"
end
