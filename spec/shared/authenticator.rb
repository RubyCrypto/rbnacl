# encoding: binary
shared_examples "authenticator" do
  let (:key)     { vector :auth_key }
  let (:message) { vector :auth_message }

  context ".new" do
    it "accepts a key" do
      expect { described_class.new(key) }.to_not raise_error(ArgumentError)
    end

    it "requires a key" do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it "raises TypeError on a nil key" do
      expect { described_class.new(nil) }.to raise_error(TypeError)
    end

    it "raises ArgumentError on a key which is too long" do
      expect { described_class.new("\0"*33) }.to raise_error(ArgumentError)
    end

    it "raises ArgumentError on a key which is too short" do
      expect { described_class.new("\0"*31) }.to raise_error(ArgumentError)
    end
  end

  context ".auth" do
    it "produces an authenticator" do
      described_class.auth(key, message).should eq tag
    end

    it "raises TypeError on a nil key" do
      expect { described_class.auth(nil, message) }.to raise_error(TypeError)
    end

    it "raises ArgumentError on a key which is too long" do
      expect { described_class.auth("\0"*33, message) }.to raise_error(ArgumentError)
    end
  end

  context ".verify" do
    it "verify an authenticator" do
      described_class.verify(key, message, tag).should eq true
    end

    it "raises TypeError on a nil key" do
      expect { described_class.verify(nil, message, tag) }.to raise_error(TypeError)
    end

    it "raises ArgumentError on a key which is too long" do
      expect { described_class.verify("\0"*33, message, tag) }.to raise_error(ArgumentError)
    end

    it "fails to validate an invalid authenticator" do
      described_class.verify(key, message+"\0", tag ).should be false
    end

    it "fails to validate a short authenticator" do
      described_class.verify(key, message, tag[0,tag.bytesize - 2]).should be false
    end

    it "fails to validate a long authenticator" do
      described_class.verify(key, message, tag+"\0").should be false
    end
  end


  context "Instance methods" do
    let(:authenticator) { described_class.new(key) }

    context "#auth" do
      it "produces an authenticator" do
        authenticator.auth(message).should eq tag
      end
    end

    context "#verify" do
      it "verifies an authenticator" do
        authenticator.verify(message, tag).should be true
      end

      it "fails to validate an invalid authenticator" do
        authenticator.verify(tag, message+"\0").should be false
      end

      it "fails to validate a short authenticator" do
        authenticator.verify(tag[0,tag.bytesize - 2], message).should be false
      end

      it "fails to validate a long authenticator" do
        authenticator.verify(tag+"\0", message).should be false
      end
    end
  end
end
