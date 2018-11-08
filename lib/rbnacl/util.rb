# encoding: binary
# frozen_string_literal: true

module RbNaCl
  # Various utility functions
  module Util
    extend Sodium

    sodium_function :c_verify16, :crypto_verify_16, %i[pointer pointer]
    sodium_function :c_verify32, :crypto_verify_32, %i[pointer pointer]
    sodium_function :c_verify64, :crypto_verify_64, %i[pointer pointer]

    module_function

    # Returns a string of n zeros
    #
    # Lots of the functions require us to create strings to pass into functions of a specified size.
    #
    # @param [Integer] n the size of the string to make
    #
    # @return [String] A nice collection of zeros
    def zeros(n = 32)
      zeros = "\0" * n
      # make sure they're 8-bit zeros, not 7-bit zeros.  Otherwise we might get
      # encoding errors later
      zeros.respond_to?(:force_encoding) ? zeros.force_encoding("ASCII-8BIT") : zeros
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
    # Many functions require a string with some zeros prepended, then need them removing after.
    # Note: this modifies the passed in string
    #
    # @param [Integer] n The number of zeros to remove
    # @param [String] message The string to be slice
    #
    # @return [String] less a bunch of zeros
    def remove_zeros(n, message)
      message.slice!(n, message.bytesize - n)
    end

    # Pad a string out to n characters with zeros
    #
    # @param [Integer] n The length of the resulting string
    # @param [String]  message the message to be padded
    #
    # @raise [RbNaCl::LengthError] If the string is too long
    #
    # @return [String] A string, n bytes long
    def zero_pad(n, message)
      len = message.bytesize
      if len == n
        message
      elsif len > n
        raise LengthError, "String too long for zero-padding to #{n} bytes"
      else
        message + zeros(n - len)
      end
    end

    # Check the length of the passed in string
    #
    # In several places through the codebase we have to be VERY strict with
    # what length of string we accept.  This method supports that.
    #
    # @raise [RbNaCl::LengthError] If the string is not the right length
    #
    # @param string [String] The string to compare
    # @param length [Integer] The desired length
    # @param description [String] Description of the string (used in the error)
    def check_length(string, length, description)
      if string.nil?
        # code below is runs only in test cases
        # nil can't be converted to str with #to_str method
        raise LengthError,
              "#{description} was nil (Expected #{length.to_int})",
              caller
      end

      if string.bytesize != length.to_int
        raise LengthError,
              "#{description} was #{string.bytesize} bytes (Expected #{length.to_int})",
              caller
      end
      true
    end

    # Check a passed in string, converting the argument if necessary
    #
    # In several places through the codebase we have to be VERY strict with
    # the strings we accept.  This method supports that.
    #
    # @raise [ArgumentError] If we cannot convert to a string with #to_str
    # @raise [RbNaCl::LengthError] If the string is not the right length
    #
    # @param string [#to_str] The input string
    # @param length [Integer] The only acceptable length of the string
    # @param description [String] Description of the string (used in the error)
    def check_string(string, length, description)
      check_string_validation(string)
      string = string.to_s
      check_length(string, length, description)

      string
    end

    # Check a passed in string, convertion if necessary
    #
    # This method will check the key, and raise error
    # if argument is not a string, and if it's empty string.
    #
    # RFC 2104 HMAC
    # The key for HMAC can be of any length (keys longer than B bytes are
    # first hashed using H). However, less than L bytes is strongly
    # discouraged as it would decrease the security strength of the
    # function.  Keys longer than L bytes are acceptable but the extra
    # length would not significantly increase the function strength. (A
    # longer key may be advisable if the randomness of the key is
    # considered weak.)
    #
    # see https://tools.ietf.org/html/rfc2104#section-3
    #
    #
    # @raise [ArgumentError] If we cannot convert to a string with #to_str
    # @raise [RbNaCl::LengthError] If the string is empty
    #
    # @param string [#to_str] The input string
    def check_hmac_key(string, _description)
      check_string_validation(string)

      string = string.to_str

      if string.bytesize.zero?
        raise LengthError,
              "#{Description} was #{string.bytesize} bytes (Expected more than 0)",
              caller
      end

      string
    end

    # Check a passed string is it valid
    #
    # Raise an error if passed argument is invalid
    #
    # @raise [TypeError] If string cannot convert to a string with #to_str
    # @raise [EncodingError] If string have wrong encoding
    #
    # @param string [#to_str] The input string
    def check_string_validation(string)
      raise TypeError, "can't convert #{string.class} into String with #to_str" unless string.respond_to? :to_str

      string = string.to_str

      raise EncodingError, "strings must use BINARY encoding (got #{string.encoding})" if string.encoding != Encoding::BINARY
    end

    # Compare two 64 byte strings in constant time
    #
    # This should help to avoid timing attacks for string comparisons in your
    # application.  Note that many of the functions (such as HmacSha512#verify)
    # use this method under the hood already.
    #
    # @param [String] one String #1
    # @param [String] two String #2
    #
    # @return [Boolean] Well, are they equal?
    def verify64(one, two)
      return false unless two.bytesize == 64 && one.bytesize == 64

      c_verify64(one, two)
    end

    # Compare two 64 byte strings in constant time
    #
    # This should help to avoid timing attacks for string comparisons in your
    # application.  Note that many of the functions (such as HmacSha512#verify)
    # use this method under the hood already.
    #
    # @param [String] one String #1
    # @param [String] two String #2
    #
    # @raise [ArgumentError] If the strings are not equal in length
    #
    # @return [Boolean] Well, are they equal?
    def verify64!(one, two)
      check_length(one, 64, "First message")
      check_length(two, 64, "Second message")
      c_verify64(one, two)
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

      c_verify32(one, two)
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
      check_length(one, 32, "First message")
      check_length(two, 32, "Second message")
      c_verify32(one, two)
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

      c_verify16(one, two)
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
      check_length(one, 16, "First message")
      check_length(two, 16, "Second message")
      c_verify16(one, two)
    end

    # Hex encodes a message
    #
    # @param [String] bytes The bytes to encode
    #
    # @return [String] Tasty, tasty hexadecimal
    def bin2hex(bytes)
      bytes.to_s.unpack("H*").first
    end

    # Hex decodes a message
    #
    # @param [String] hex hex to decode.
    #
    # @return [String] crisp and clean bytes
    def hex2bin(hex)
      [hex.to_s].pack("H*")
    end
  end
end
