# Requires the base32 gem
require 'base32'

module Crypto
  module Encoders
    # Base64 encoding provider
    #
    # Accessable as Crypto::Encoder[:base64]
    #
    class Base32 < Crypto::Encoder
      register :base32

      # Base64 encodes a message
      #
      # @param [String] bytes The bytes to encode
      #
      # @return [String] Lovely, elegant "Zooko-style" Base32
      def encode(bytes)
        ::Base32.encode(bytes.to_s).downcase
      end

      # Hex decodes a message
      #
      # @param [String] base32 string to decode.
      #
      # @return [String] crisp and clean bytes
      def decode(base32)
        ::Base32.decode(base32.to_s.upcase)
      end
    end
  end
end