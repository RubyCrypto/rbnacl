# frozen_string_literal: true

RSpec.describe RbNaCl::Sodium do
  subject(:sodium_class) do
    class SodiumExtendedClass
      extend RbNaCl::Sodium

      sodium_type :auth
      sodium_primitive :hmacsha512
      # sodium_constant :BYTES
      # sodium_constant :KEYBYTES
    end
    SodiumExtendedClass
  end

  context ".sodium_constant" do
    it "retrieves the libsodium constant" do
      sodium_class.sodium_constant :BYTES
      expect(sodium_class::BYTES).to eq(64)
    end

    context "with alternate constant name" do
      it "sets the alternate constant name" do
        sodium_class.sodium_constant :BYTES, name: :COOL_BYTES
        expect(sodium_class::COOL_BYTES).to eq(64)
      end
    end

    context "when libsodium does not define the constant" do
      it "raises an exception" do
        expect do
          sodium_class.sodium_constant :MIN_DANCING_PARTNERS
        end.to raise_error(FFI::NotFoundError)
      end
    end

    context "with fallback" do
      context "when libsodium defines the constant" do
        it "return the libsodium value" do
          sodium_class.sodium_constant :BYTES, fallback: 888
          expect(sodium_class::BYTES).to eq(64)
        end
      end

      context "when libsodium does not define the constant" do
        it "uses the fallback" do
          sodium_class.sodium_constant :MAX_PANDAS, fallback: 24
          expect(sodium_class::MAX_PANDAS).to eq(24)
        end
      end
    end
  end
end
