# encoding: binary
# frozen_string_literal: true

RSpec.shared_examples "HMAC" do
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

  context "Instance methods" do
    let(:authenticator) { described_class.new(key) }

    before(:each) { authenticator.update(message) }

    context "#update" do
      it "returns hexdigest when produces an authenticator" do
        expect(authenticator.update(message)).to eq mult_tag.unpack("H*").first
      end
    end

    context "#digest" do
      it "returns an authenticator" do
        expect(authenticator.digest).to eq tag
      end
    end

    context "#hexdigest" do
      it "returns hex authenticator" do
        expect(authenticator.hexdigest).to eq tag.unpack("H*").first
      end
    end
  end
end
