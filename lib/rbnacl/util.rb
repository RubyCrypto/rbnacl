#!/usr/bin/env ruby
module Crypto
  # Various utility functions
  module Util
    # Returns a string of n zeros
    #
    # Lots of the functions require us to create strings to pass into functions of a specified size.
    #
    # @param [Integer] n the size of the string to make
    #
    # @return [String] A nice collection of zeros
    def self.zeros(n=32)
      zeros = "\0" * n
      # make sure they're 8-bit zeros, not 7-bit zeros.  Otherwise we might get
      # encoding errors later
      zeros.respond_to?(:force_encoding) ? zeros.force_encoding('ASCII-8BIT') : zeros
    end

    # Prepends a message with zeros
    #
    # Many functions require a string with some zeros prepended.
    #
    # @param [Integer] n The number of zeros to prepend
    # @param [String] message The string to be prepended
    #
    # @return [String] a bunch of zeros
    def self.prepend_zeros(n, message)
      zeros(n) + message
    end

    # Remove zeros from the start of a message
    #
    # Many functions require a string with some zeros prepended, then need them removing after.  Note, this modifies the passed in string
    #
    # @param [Integer] n The number of zeros to remove
    # @param [String] message The string to be slice
    #
    # @return [String] less a bunch of zeros
    def self.remove_zeros(n, message)
      message.slice!(n, message.bytesize - n)
    end

    # Compare two 32 byte strings in constant time
    #
    # This should help to avoid timing attacks for string comparisons in your
    # application.  Note that many of the functions (such as HmacSha256#verify)
    # use this method under the hood already.
    #
    # @param [String] one String #1
    # @param [String] two String #2
    #
    # @raise [ArgumentError] If the strings are not equal
    #
    # @return [Boolean] Well, are they equal?
    def self.verify32(one, two)
      raise(ArgumentError, "First message was #{one.bytesize} bytes, not 32") unless one.bytesize == 32
      raise(ArgumentError, "Second message was #{two.bytesize} bytes, not 32") unless two.bytesize == 32
      NaCl.crypto_verify_32(one, two)
    end
    
    
    # Compare two 16 byte strings in constant time
    #
    # This should help to avoid timing attacks for string comparisons in your
    # application.  Note that many of the functions (such as OneTime#verify)
    # use this method under the hood already.
    #
    # @param [String] one String #1
    # @param [String] two String #2
    #
    # @raise [ArgumentError] If the strings are not equal
    #
    # @return [Boolean] Well, are they equal?
    def self.verify16(one, two)
      raise(ArgumentError, "First message was #{one.bytesize} bytes, not 16") unless one.bytesize == 16
      raise(ArgumentError, "Second message was #{two.bytesize} bytes, not 16") unless two.bytesize == 16
      NaCl.crypto_verify_16(one, two)
    end
  end
end

