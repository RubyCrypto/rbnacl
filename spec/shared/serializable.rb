# encoding: binary

shared_examples "serializable" do
  context "serialization" do
    it "supports #to_s" do
      expect(subject.to_s).to be_a String
    end

    it "supports #to_str" do
      expect(subject.to_str).to be_a String
    end

    it "supports #inspect" do
      expect(subject.inspect).to be_a String
    end
  end
end
