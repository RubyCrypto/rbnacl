module Crypto
  # Serialization features shared across all "key-like" classes
  module Serializable
    # Return a string representation of this key, possibly encoded into a
    # given serialization format.
    #
    # @param encoding [String] string encoding format in which to encode the key
    #
    # @return [String] key encoded in the specified format
    def to_s(encoding = :raw)
      Encoder[encoding].encode(to_bytes)
    end
    alias_method :to_str, :to_s

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<#{self.class}:#{to_s(:hex)[0,8]}>"
    end
  end
end