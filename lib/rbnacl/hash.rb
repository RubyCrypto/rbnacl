# encoding: binary
module Crypto
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
  # RbNaCl provides the SHA-256 and SHA-512 hash functions.
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

    if NaCl.supported_version? :libsodium, '0.4.0'
      # Returns the Blake2b hash of the given data
      #
      # There's no streaming done, just pass in the data and be done with it.
      # This method returns a 64-byte hash.
      #
      # @param [String] data The data, as a collection of bytes
      # @param [#to_sym] encoding Encoding of the returned hash.
      #
      # @raise [CryptoError] If the hashing fails for some reason.
      #
      # @return [String] The blake2b hash as raw bytes (Or encoded as per the second argument)
      def self.blake2b(data, encoding = :raw)
        hash = Util.zeros(NaCl::BLAKE2B_OUTBYTES)
        NaCl.crypto_hash_blake2b(hash, NaCl::BLAKE2B_OUTBYTES, data, data.bytesize, nil, 0) || raise(CryptoError, "Hashing failed!")
        Encoder[encoding].encode(hash)
      end
    else
      def self.blake2b(data, encoding = :raw)
        raise NotImplementedError, "not supported by this version of libsodium"
      end
    end
  end
end
