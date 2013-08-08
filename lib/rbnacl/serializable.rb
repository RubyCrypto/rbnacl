# encoding: binary
module Crypto
  # Serialization features shared across all "key-like" classes
  module Serializable
    def to_s;   to_bytes; end
    def to_str; to_bytes; end

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<#{self.class}:#{to_s(:hex)[0,8]}>"
    end
  end
end