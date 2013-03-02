# encoding: binary
module Crypto
  module Encoders
    # Raw encoder which only does a string conversion (if necessary)
    class Raw < Crypto::Encoder
      register :raw

      def encode(bytes); bytes.to_s; end
      def decode(bytes); bytes.to_s; end
    end
  end
end