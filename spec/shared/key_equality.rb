# encoding: binary
RSpec.shared_examples "key equality" do
  context "equality" do
    it "equal keys are equal" do
      expect(described_class.new(key_bytes) == key).to be true
    end
    it "equal keys are equal to the string" do
      expect(key == key_bytes).to be true
    end
    it "keys are not equal to zero" do
      expect(key == RbNaCl::Util.zeros(32)).to be false
    end
    it "keys are not equal to another key" do
      expect(key == other_key).to be false
    end
  end

  context "lexicographic sorting" do
    it "can be compared lexicographically to a key smaller than it" do
      expect(key > RbNaCl::Util.zeros(32)).to be true
    end
    it "can be compared lexicographically to a key larger than it" do
      expect(described_class.new(RbNaCl::Util.zeros(32)) < key).to be true
    end
  end
end
