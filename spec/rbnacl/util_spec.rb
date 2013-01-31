describe Crypto::Util do
  context ".verify32" do
    let (:msg) { Crypto::Util.zeros(32) }
    let (:identical_msg) { Crypto::Util.zeros(32) }
    let (:other_msg) { Crypto::Util.zeros(31) + "\001" }
    let (:short_msg) { Crypto::Util.zeros(31) }
    let (:long_msg) { Crypto::Util.zeros(33) }

    it "confirms identical messages are identical" do
      Crypto::Util.verify32(msg, identical_msg).should be true
    end

    it "confirms non-identical messages are non-identical" do
      Crypto::Util.verify32(msg, other_msg).should be false
      Crypto::Util.verify32(other_msg, msg).should be false
    end

    it "raises descriptively on a short message in position 1" do
      expect { Crypto::Util.verify32(short_msg, msg) }.to raise_error(ArgumentError, /First message was 31 bytes, not 32/)
    end
    it "raises descriptively on a short message in position 2" do
      expect { Crypto::Util.verify32(msg, short_msg) }.to raise_error(ArgumentError, /Second message was 31 bytes, not 32/)
    end
    it "raises descriptively on a long message in position 1" do
      expect { Crypto::Util.verify32(long_msg, msg) }.to raise_error(ArgumentError, /First message was 33 bytes, not 32/)
    end
    it "raises descriptively on a long message in position 2" do
      expect { Crypto::Util.verify32(msg, long_msg) }.to raise_error(ArgumentError, /Second message was 33 bytes, not 32/)
    end
  end

  context ".verify16" do
    let (:msg) { Crypto::Util.zeros(16) }
    let (:identical_msg) { Crypto::Util.zeros(16) }
    let (:other_msg) { Crypto::Util.zeros(15) + "\001" }
    let (:short_msg) { Crypto::Util.zeros(15) }
    let (:long_msg) { Crypto::Util.zeros(17) }

    it "confirms identical messages are identical" do
      Crypto::Util.verify16(msg, identical_msg).should be true
    end

    it "confirms non-identical messages are non-identical" do
      Crypto::Util.verify16(msg, other_msg).should be false
      Crypto::Util.verify16(other_msg, msg).should be false
    end

    it "raises descriptively on a short message in position 1" do
      expect { Crypto::Util.verify16(short_msg, msg) }.to raise_error(ArgumentError, /First message was 15 bytes, not 16/)
    end
    it "raises descriptively on a short message in position 2" do
      expect { Crypto::Util.verify16(msg, short_msg) }.to raise_error(ArgumentError, /Second message was 15 bytes, not 16/)
    end
    it "raises descriptively on a long message in position 1" do
      expect { Crypto::Util.verify16(long_msg, msg) }.to raise_error(ArgumentError, /First message was 17 bytes, not 16/)
    end
    it "raises descriptively on a long message in position 2" do
      expect { Crypto::Util.verify16(msg, long_msg) }.to raise_error(ArgumentError, /Second message was 17 bytes, not 16/)
    end
  end
end
