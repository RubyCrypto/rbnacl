#!/usr/bin/env ruby
module Crypto
  module Hash
    # Returns the SHA-256 hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    #
    # @param [String] data The data, as a collection of bytes
    #
    # @raise [CryptoError] If the hashing fails for some unknown reason.
    #
    # @return [String] The SHA-256 hash as raw bytes (NOT hex encoded)
    def self.sha256(data)
      hash = Util.zeros(NaCl::SHA256BYTES)
      NaCl.crypto_hash_sha256(hash, data, data.bytesize) || raise(CryptoError, "Hashing failed!")
      hash
    end
  end
end
