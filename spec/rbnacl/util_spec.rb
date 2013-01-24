describe Crypto::Util do
  context "Hex Encoding" do
    let (:bytes) { [0xDE,0xAD,0xBE,0xEF].pack('c*') }
    let (:hex)  { "deadbeef"  }
    it "hex encodes" do
      described_class.hexencode(bytes).should eq hex
    end
    it "hex decodes" do
      described_class.hexdecode(hex).should eq bytes
    end
  end
end
