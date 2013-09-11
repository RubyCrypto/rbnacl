# encoding: binary
module RbNaCl
  # Serialization features shared across all "key-like" classes
  module Serializable
    def to_s;   to_bytes; end
    def to_str; to_bytes; end

    # Inspect this key
    #
    # @return [String] a string representing this key
    def inspect
      "#<#{self.class}:#{Util.bin2hex(to_bytes)[0,8]}>"
    end
  end
end