module Crypto
  # Scalars provide the interface to NaCl's Curve25519 high-speed elliptic
  # curve cryptography, which can be used for implementing Diffie-Hellman
  # and other forms of public key cryptography.
  #
  # Generally you shouldn't need to use Scalars directly. Rather, they are
  # leveraged elsewhere in RbNaCl
  class Scalar
    # Create a new Scalar from a 32-byte value
    #
    # @param value [String] Random 32-byte value (i.e. private key)
    # @param encoding [Symbol] Parse value with the given encoding
    #
    # @return [Crypto::Scalar] Object representing Curve25519 scalars
    def initialize(value, encoding = :raw)
      @value = Encoder[encoding].decode(value)

      if @value.bytesize != NaCl::SCALARBYTES
        raise ArgumentError, "value must be exactly #{NaCl::SCALARBYTES} bytes"
      end
    end

    # Computes the scalar product of a standard group element (i.e. constant
    # hardcoded into NaCl) and this scalar object.
    #
    # @param encoding [Symbol] Encode computed group element in this format
    #
    # @return [String] New group element, serialized in the given format
    def mult_base(encoding = :raw)
      result = Util.zeros(NaCl::SCALARBYTES)
      NaCl.crypto_scalarmult_base(result, @value)

      Encoder[encoding].encode(result)
    end

    def to_bytes; @value; end

    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end

    def inspect
      "#<#{self.class}:#{to_s(:hex)}>"
    end
  end
end
