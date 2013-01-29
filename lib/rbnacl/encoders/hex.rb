module Crypto
  module Encoders
    # Hex encoding provider
    #
    # Accessable as Crypto::Encoder[:hex]
    #
    class Hex < Crypto::Encoder
      register :hex

      # Hex encodes a message
      #
      # @param [String] bytes The bytes to encode
      #
      # @return [String] Tasty, tasty hexidecimal
      def encode(bytes)
        bytes.unpack("H*").first
      end

      # Hex decodes a message
      #
      # @param [String] hex hex to decode.
      #
      # @return [String] crisp and clean bytes
      def decode(hex)
        [hex].pack("H*")
      end
    end
  end
end