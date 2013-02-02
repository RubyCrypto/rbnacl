#!/usr/bin/env ruby
module Crypto
  module Hash
    # Returns the SHA-256 hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    #
    # @param [String] data The data, as a collection of bytes
    # @param [#to_sym] encoding Encoding of the returned hash.
    #
    # @raise [CryptoError] If the hashing fails for some reason.
    #
    # @return [String] The SHA-256 hash as raw bytes (Or encoded as per the second argument)
    def self.sha256(data, encoding = :raw)
      hash = Util.zeros(NaCl::SHA256BYTES)
      NaCl.crypto_hash_sha256(hash, data, data.bytesize) || raise(CryptoError, "Hashing failed!")
      Encoder[encoding].encode(hash)
    end

    # Returns the SHA-512 hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    #
    # @param [String] data The data, as a collection of bytes
    # @param [#to_sym] encoding Encoding of the returned hash.
    #
    # @raise [CryptoError] If the hashing fails for some reason.
    #
    # @return [String] The SHA-512 hash as raw bytes (Or encoded as per the second argument)
    def self.sha512(data, encoding = :raw)
      hash = Util.zeros(NaCl::SHA512BYTES)
      NaCl.crypto_hash_sha512(hash, data, data.bytesize) || raise(CryptoError, "Hashing failed!")
      Encoder[encoding].encode(hash)
    end
  end
end
