shared_examples "auth_hmac" do
  context ".new" do
    it "accepts a key" do
      expect { described_class.new(rfc_key)  }.to_not raise_error(ArgumentError)
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
      described_class.auth(rfc_key, rfc_data).should eq rfc_result
    end

    it "raises on a nil key" do
      expect { described_class.auth(nil, rfc_data)  }.to raise_error(ArgumentError)
    end

    it "raises on a key which is too long" do
      expect { described_class.auth("\0"*33, rfc_data)  }.to raise_error(ArgumentError)
    end
  end

  context ".verify" do
    it "verify an authenticator" do
      described_class.verify(rfc_key, rfc_result, rfc_data).should eq true
    end

    it "raises on a nil key" do
      expect { described_class.verify(nil, rfc_result, rfc_data)  }.to raise_error(ArgumentError)
    end

    it "raises on a key which is too long" do
      expect { described_class.verify("\0"*33, rfc_result, rfc_data)  }.to raise_error(ArgumentError)
    end

    it "fails to validate an invalid authenticator" do
      described_class.verify(rfc_key, rfc_result, rfc_data+"\0").should be false
    end
    it "fails to validate a short authenticator" do
      described_class.verify(rfc_key, rfc_result[0,31], rfc_data).should be false
    end
    it "fails to validate a long authenticator" do
      described_class.verify(rfc_key, rfc_result+"\0", rfc_data).should be false
    end
  end


  context "Instance methods" do
    let(:hmac) { described_class.new(rfc_key) }
    let(:rfc_hex) { Crypto::Util.hexencode(rfc_result)  }
    context "#auth" do
      it "produces an authenticator" do
        hmac.auth(rfc_data).should eq rfc_result
      end
    end

    context "#hexauth" do
      it "produces a hex encoded authenticator" do
        hmac.hexauth(rfc_data).should eq rfc_hex
      end
    end

    context "#verify" do
      it "verifies an authenticator" do
        hmac.verify(rfc_result, rfc_data).should be true
      end
      it "fails to validate an invalid authenticator" do
        hmac.verify(rfc_result, rfc_data+"\0").should be false
      end
      it "fails to validate a short authenticator" do
        hmac.verify(rfc_result[0,31], rfc_data).should be false
      end
      it "fails to validate a long authenticator" do
        hmac.verify(rfc_result+"\0", rfc_data).should be false
      end
    end
    
    context "#hexverify" do
      it "verifies an hexencoded authenticator" do
        hmac.hexverify(rfc_hex, rfc_data).should be true
      end
      it "fails to validate an invalid authenticator" do
        hmac.hexverify(rfc_hex, rfc_data+"\0").should be false
      end
      it "fails to validate a short authenticator" do
        hmac.hexverify(rfc_hex[0,62], rfc_data).should be false
      end
      it "fails to validate a long authenticator" do
        hmac.hexverify(rfc_hex+"00", rfc_data).should be false
      end
    end
  end
end
