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
      "\0" * n
    end
  end
end

