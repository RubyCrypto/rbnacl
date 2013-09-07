# encoding: binary
shared_examples "key equality" do
  context "equality" do
    it "equal keys are equal" do
      (described_class.new(key_bytes) == key).should be true
    end
    it "equal keys are equal to the string" do
      (key == key_bytes).should be true
    end
    it "keys are not equal to zero" do
      (key == RbNaCl::Util.zeros(32)).should be false
    end
    it "keys are not equal to another key" do
      (key == other_key).should be false
    end
  end

  context "lexicographic sorting" do
    it "can be compared lexicographically to a key smaller than it" do
      (key > RbNaCl::Util.zeros(32)).should be true
    end
    it "can be compared lexicographically to a key larger than it" do
      (described_class.new(RbNaCl::Util.zeros(32)) < key).should be true
    end
  end
end
