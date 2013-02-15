module Crypto
  # NaCl's base point (a.k.a. standard group element), serialized as hex
  STANDARD_GROUP_ELEMENT = "0900000000000000000000000000000000000000000000000000000000000000".freeze

  # Order of the standard group
  STANDARD_GROUP_ORDER = 2**252 + 27742317777372353535851937790883648493

  # Points provide the interface to NaCl's Curve25519 high-speed elliptic
  # curve cryptography, which can be used for implementing Diffie-Hellman
  # and other forms of public key cryptography (e.g. Crypto::Box)
  #
  # Objects of the Point class represent points on Edwards curves. NaCl
  # defines a base point (the "standard group element") which we can
  # multiply by an arbitrary integer. This is how NaCl computes public
  # keys from private keys.
  class Point
    include KeyComparator

    # Creates a new Point from the given serialization
    #
    # @param value [String] 32-byte value representing a group element
    # @param encoding [Symbol] The encoding format of the group element
    #
    # @return [Crypto::Point] New Crypto::Point object
    def initialize(value, encoding = :raw)
      @point = Encoder[encoding].decode(value)

      # FIXME: really should have a separate constant here for group element size
      # Group elements and scalars are both 32-bits, but that's for convenience
      Util.check_length(@point, NaCl::SCALARBYTES, "group element")
    end

    # Multiply the given integer by this point
    # This ordering is a bit confusing because traditionally the point
    # would be the right-hand operand.
    #
    # @param integer [String] 32-byte integer value
    # @param encoding [Symbol] The encoding format of the integer
    #
    # @return [Crypto::Point] Result as a Point object
    def mult(integer, encoding = :raw)
      integer = Encoder[encoding].decode(integer)

      if integer.bytesize != NaCl::SCALARBYTES
        raise ArgumentError, "integer must be exactly #{NaCl::SCALARBYTES} bytes"
      end

      result = Util.zeros(NaCl::SCALARBYTES)
      NaCl.crypto_scalarmult(result, integer, @point)

      self.class.new(result)
    end

    # Return the point serialized as bytes
    #
    # @return [String] 32-byte string representing this point
    def to_bytes; @point; end

    # Return a string representation of this point, possibly encoded into a
    # given serialization format.
    #
    # @param encoding [String] string encoding format in which to encode the point
    #
    # @return [String] point encoded in the specified format
    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end
    alias_method :to_str, :to_s

    # Inspect this point
    #
    # @return [String] a string representing this point
    def inspect
      "#<#{self.class}:#{to_s(:hex)}>"
    end

    # NaCl's standard base point for all Curve25519 public keys
    #
    # @return [Crypto::Point] standard base point (a.k.a. standard group element)
    def self.base; @base_point; end
    @base_point = Point.new Crypto::Encoder[:hex].decode(STANDARD_GROUP_ELEMENT)

    class << self
      alias_method :base_point, :base
    end
  end
end
   
