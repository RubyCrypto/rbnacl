# encoding: binary
module Crypto
  # A Ciphertext returned by the library
  #
  # Holds the ciphertext returned by the library.  This acts like a string in
  # many cases, but also supports interrogating for the primitive used and can
  # be encoded into a variety of formats.
  class Ciphertext
    attr_reader :ciphertext, :primitive
    attr_accessor :default_encoding
    def initialize(ciphertext, primitive, default_encoding = :raw)
      @ciphertext       = ciphertext
      @primitive        = primitive
      @default_encoding = default_encoding
    end

    # Returns the ciphertext string
    #
    # Optionally encodes it too
    #
    # @param encoding [Symbol] encoding to use
    #
    # @return [String] ciphertext
    def to_str(encoding = default_encoding)
      Encoder[encoding].encode(ciphertext)
    end

    alias to_s to_str


    def inspect
      "#<#{self.class}:#{primitive}:#{to_str(:hex)[0,16]}>"
    end
    
    # size of the ciphertext in bytes
    #
    # This returns the size in the specified encoding, to avoid confusion
    # in the case of a non-raw default encoding.
    #
    # @param encoding [Symbol] encoding to use
    #
    # @return [Integer bytesize of encoded ciphertext
    def bytesize(encoding = default_encoding)
      to_s(encoding).bytesize
    end

    # Concatenate a string
    def +(thing)
      to_s + thing.to_s
    end

    # tests for equality by converting a to string
    def ==(thing)
      thing.respond_to?(:to_s) ? to_s == thing.to_s : false
    end
  end
end
