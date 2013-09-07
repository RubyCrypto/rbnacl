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
      # @param [Hash] opts Blake2b configuration
      # @option opts [String]  :key for Blake2b keyed mode
      # @option opts [Integer] :digest_size size of output digest in bytes
      #
      # @raise [Crypto::LengthError] Invalid length specified for one or more options
      #
      # @return [Crypto::Hash::Blake2b] A Blake2b hasher object
      def initialize(opts = {})
        @key = opts.fetch(:key, nil)
        @key_size = @key ? @key.bytesize : 0
        raise LengthError, "key too long" if @key_size > NaCl::BLAKE2B_KEYBYTES

        @digest_size = opts.fetch(:digest_size, NaCl::BLAKE2B_OUTBYTES)
        raise LengthError, "invalid digest size" if @digest_size < 1 || @digest_size > NaCl::BLAKE2B_OUTBYTES
      end

      # Calculate a Blake2b digest
      #
      # @param [String] message Message to be hashed
      #
      # @return [String] Blake2b digest of the string as raw bytes
      def digest(message)
        digest = Util.zeros(@digest_size)
        NaCl.crypto_hash_blake2b(digest, @digest_size, message, message.bytesize, @key, @key_size) || raise(CryptoError, "Hashing failed!")
        digest
      end
    end
  end
end
