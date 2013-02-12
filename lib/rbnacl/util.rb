#!/usr/bin/env ruby
module Crypto
  # Various utility functions
  module Util
    module_function
    # Returns a string of n zeros
    #
    # Lots of the functions require us to create strings to pass into functions of a specified size.
    #
    # @param [Integer] n the size of the string to make
    #
    # @return [String] A nice collection of zeros
    def zeros(n=32)
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
    def prepend_zeros(n, message)
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
    def remove_zeros(n, message)
      message.slice!(n, message.bytesize - n)
    end

    # Check the length of the passed in string
    #
    # In several places through the codebase we have to be VERY strict with
    # what length of string we accept.  This method supports that.
    #
    # @raise [Crypto::LengthError] If the string is not the right length
    #
    # @param string [String] The string to compare
    # @param length [Integer] The desired length
    # @param description [String] Description of the string (used in the error)
    def check_length(string, length, description)
      if string.nil?
        raise LengthError,
          "#{description} was #{nil} (Expected #{length.to_int})",
          caller
      end
      
      if string.bytesize != length.to_int
        raise LengthError,
              "#{description} was #{string.bytesize} bytes (Expected #{length.to_int})",
              caller
      end
      true
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
    # @return [Boolean] Well, are they equal?
    def verify32(one, two)
      return false unless two.bytesize == 32 && one.bytesize == 32
      NaCl.crypto_verify_32(one, two)
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
    # @raise [ArgumentError] If the strings are not equal in length
    #
    # @return [Boolean] Well, are they equal?
    def verify32!(one, two)
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
    # @return [Boolean] Well, are they equal?
    def verify16(one, two)
      return false unless two.bytesize == 16 && one.bytesize == 16
      NaCl.crypto_verify_16(one, two)
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
    # @raise [ArgumentError] If the strings are not equal in length
    #
    # @return [Boolean] Well, are they equal?
    def verify16!(one, two)
      raise(ArgumentError, "First message was #{one.bytesize} bytes, not 16") unless one.bytesize == 16
      raise(ArgumentError, "Second message was #{two.bytesize} bytes, not 16") unless two.bytesize == 16
      NaCl.crypto_verify_16(one, two)
    end
  end
end

