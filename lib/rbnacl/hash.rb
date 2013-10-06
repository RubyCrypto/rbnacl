# encoding: binary
module RbNaCl
  # Cryptographic hash functions
  #
  # Cryptographic hash functions take a variable length message and compute a
  # fixed length string, the message digest. Even a small change in the input
  # data should produce a large change in the digest, and it is 'very difficult'
  # to create two messages with the same digest.
  #
  # A cryptographic hash can be used for checking the integrity of data, but
  # there is no secret involved in the hashing, so anyone can create the hash of
  # a given message.
  #
  # RbNaCl provides the SHA-256,SHA-512 as well as the Blake2b hash functions.
  module Hash
    # Returns the SHA-256 hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    #
    # @param [#to_str] data The data, as a collection of bytes
    #
    # @raise [CryptoError] If the hashing fails for some reason.
    #
    # @return [String] The SHA-256 hash as raw bytes (Or encoded as per the second argument)
    def self.sha256(data)
      data   = data.to_str
      digest = Util.zeros(SHA256::BYTES)
      SHA256.hash_sha256(digest, data, data.bytesize) || raise(CryptoError, "Hashing failed!")
      digest
    end

    # Returns the SHA-512 hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    #
    # @param [#to_str] data The data, as a collection of bytes
    #
    # @raise [CryptoError] If the hashing fails for some reason.
    #
    # @return [String] The SHA-512 hash as raw bytes (Or encoded as per the second argument)
    def self.sha512(data)
      digest = Util.zeros(SHA512::BYTES)
      SHA512.hash_sha512(digest, data, data.bytesize) || raise(CryptoError, "Hashing failed!")
      digest
    end

    # Returns the Blake2b hash of the given data
    #
    # There's no streaming done, just pass in the data and be done with it.
    # This method returns a 64-byte hash by default.
    #
    # @param [String] data The data, as a collection of bytes
    # @option options [Fixnum] digest_size Size in bytes (1-64, default 64)
    # @option options [String] key 64-byte (or less) key for keyed mode
    #
    # @raise [CryptoError] If the hashing fails for some reason.
    #
    # @return [String] The blake2b hash as raw bytes (Or encoded as per the second argument)
    def self.blake2b(data, options = {})
      key         = options[:key]
      Blake2b.new(options).digest(data)
    end
  end
end
