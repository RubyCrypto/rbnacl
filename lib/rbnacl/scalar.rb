module Crypto
  # Scalars provide the interface to NaCl's Curve25519 high-speed elliptic
  # curve cryptography, which can be used for implementing Diffie-Hellman
  # and other forms of public key cryptography.
  #
  # Generally you shouldn't need to use Scalars directly. Rather, they are
  # leveraged elsewhere in RbNaCl
  module Scalar
    # Expose all methods on the Scalar module itself
    module_function

    # Standard group element used for computing Curve25519 public keys
    STANDARD_GROUP_ELEMENT = "\t\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0".freeze

    # Computes the scalar product of a group element and an integer. This is
    # useful for algorithms like Diffie-Hellman.
    #
    # @param value [String] 32-byte integer value
    # @param group_element [String] 32-byte group element
    # @param encoding [Symbol] Use the given encoding for input/output
    #
    # @return [String] New group element, serialized in the given format
    def mult(value, group_element, encoding = :raw)
      value         = Encoder[encoding].decode(value)
      group_element = Encoder[encoding].decode(group_element)

      if value.bytesize != NaCl::SCALARBYTES
        raise ArgumentError, "integer value must be exactly #{NaCl::SCALARBYTES} bytes"
      end

      if group_element.bytesize != NaCl::SCALARBYTES
        raise ArgumentError, "group element must be exactly #{NaCl::SCALARBYTES} bytes"
      end

      result = Util.zeros(NaCl::SCALARBYTES)
      NaCl.crypto_scalarmult(result, value, group_element)

      Encoder[encoding].encode(result)
    end

    # Computes the scalar product of a standard group element (i.e. constant
    # hardcoded into NaCl) and the given integer. The standard group element
    # is used for computing all Curve25519 public keys used by other NaCl
    # algorithms (e.g. Crypto::Box, Crypto::SigningKey/VerifyKey)
    #
    # @param value [String] 32-byte value (i.e. private key)
    # @param encoding [Symbol] Use the given encoding for input/output
    #
    # @return [String] New group element, serialized in the given format
    def mult_base(value, encoding = :raw)
      mult(value, STANDARD_GROUP_ELEMENT, encoding)
    end
  end
end
