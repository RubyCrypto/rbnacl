module Crypto
  module Hash
    # The Blake2b hash function
    #
    # Blake2b is based on Blake, a SHA3 finalist which was snubbed in favor of
    # Keccak, a much slower hash function but one sufficiently different from
    # SHA2 to let the SHA3 judges panel sleep easy. Back in the real world,
    # it'd be great if we can calculate hashes quickly if possible.
    #
    # Blake2b provides for up to 64-bit digests and also supports a keyed mode
    # similar to HMAC
    class Blake2b
      # Create a new Blake2b hash object
      #
      # @param [String] key Optional 64-byte (or less) key for keyed mode
      #
      # @raise [Crypto::LengthError] Key was too long
      #
      # @return [Crypto::Hash::Blake2b] A Blake2b hasher object
      def initialize(key = nil)
        raise LengthError, "key too long" if key && key.bytesize > NaCl::BLAKE2B_KEYBYTES

        @key      = key
        @key_size = key ? key.bytesize : 0
      end

      # Calculate a Blake2b hash
      #
      # @param [String] message Message to be hashed
      # @param [Fixnum] digest_size Optional byte size (must be < 64, default 64)
      #
      # @raise [Crypto::LengthError] Something went wrong calculating the hash
      #
      # @return [String] Blake2b digest of the string as raw bytes
      def hash(message, digest_size = NaCl::BLAKE2B_OUTBYTES)
        raise LengthError, "invalid digest size " if digest_size < 1 || digest_size > NaCl::BLAKE2B_KEYBYTES
        digest = Util.zeros(NaCl::BLAKE2B_OUTBYTES)
        NaCl.crypto_hash_blake2b(digest, digest_size, message, message.bytesize, @key, @key_size) || raise(CryptoError, "Hashing failed!")
        digest
      end
    end
  end
end