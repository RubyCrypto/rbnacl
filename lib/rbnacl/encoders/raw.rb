module Crypto
  module Encoders
    # Null encoder that does no transformations
    class Raw < Crypto::Encoder
      register :raw

      def encode(bytes); bytes; end
      def decode(bytes); bytes; end
    end
  end
end