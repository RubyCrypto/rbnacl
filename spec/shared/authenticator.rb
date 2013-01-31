shared_examples "authenticator" do
  context ".new" do
    it "accepts a key" do
      expect { described_class.new(key)  }.to_not raise_error(ArgumentError)
    end

    it "requires a key" do
      expect { described_class.new  }.to raise_error(ArgumentError)
    end

    it "raises on a nil key" do
      expect { described_class.new(nil)  }.to raise_error(ArgumentError)
    end

    it "raises on a key which is too long" do
      expect { described_class.new("\0"*33)  }.to raise_error(ArgumentError)
    end
  end

  context ".auth" do
    it "produces an authenticator" do
      described_class.auth(key, message).should eq tag
    end

    it "raises on a nil key" do
      expect { described_class.auth(nil, message)  }.to raise_error(ArgumentError)
    end

    it "raises on a key which is too long" do
      expect { described_class.auth("\0"*33, message)  }.to raise_error(ArgumentError)
    end
  end

  context ".verify" do
    it "verify an authenticator" do
      described_class.verify(key, tag, message).should eq true
    end

    it "raises on a nil key" do
      expect { described_class.verify(nil, tag, message)  }.to raise_error(ArgumentError)
    end

    it "raises on a key which is too long" do
      expect { described_class.verify("\0"*33, tag, message)  }.to raise_error(ArgumentError)
    end

    it "fails to validate an invalid authenticator" do
      described_class.verify(key, tag, message+"\0").should be false
    end
    it "fails to validate a short authenticator" do
      described_class.verify(key, tag[0,tag.bytesize - 2], message).should be false
    end
    it "fails to validate a long authenticator" do
      described_class.verify(key, tag+"\0", message).should be false
    end
  end


  context "Instance methods" do
    let(:authenticator) { described_class.new(key) }
    let(:hex) { Crypto::Encoder[:hex].encode(tag)  }

    context "#auth" do
      it "produces an authenticator" do
        authenticator.auth(message).should eq tag
      end

      it "produces a hex encoded authenticator" do
        authenticator.auth(message, :hex).should eq hex
      end
    end

    context "#verify" do
      context "raw bytes" do
        it "verifies an authenticator" do
          authenticator.verify(tag, message).should be true
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

      context "hex" do
        it "verifies an hexencoded authenticator" do
          authenticator.verify(hex, message, :hex).should be true
        end
        it "fails to validate an invalid authenticator" do
          authenticator.verify(hex, message+"\0", :hex).should be false
        end
        it "fails to validate a short authenticator" do
          authenticator.verify(hex[0,hex.bytesize - 2], message, :hex).should be false
        end
        it "fails to validate a long authenticator" do
          authenticator.verify(hex+"00", message, :hex).should be false
        end
      end
    end
  end
end
