#!/usr/bin/env ruby
module Crypto
  # Functions for random number generation
  #
  # This uses the underlying source of random number generation on the OS, so
  # /dev/urandom on UNIX-like systems, and the MS crypto providor on windows.
  module Random
    # Returns a string of random bytes
    #
    # @param [Integer] n number of random bytes desired
    #
    # @return [String] random bytes.
    def self.random_bytes(n=32)
      buf = Crypto::Util.zeros(n)
      NaCl.random_bytes(buf, n)
      buf
    end
  end
end
