# encoding: binary
# frozen_string_literal: true

module RbNaCl
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
      extend Sodium

      sodium_type :generichash
      sodium_primitive :blake2b
      sodium_constant :BYTES_MIN
      sodium_constant :BYTES_MAX
      sodium_constant :KEYBYTES_MIN
      sodium_constant :KEYBYTES_MAX
      sodium_constant  :SALTBYTES
      sodium_constant  :PERSONALBYTES

      sodium_function  :generichash_blake2b,
                       :crypto_generichash_blake2b_salt_personal,
                       %i[pointer size_t pointer ulong_long pointer size_t pointer pointer]

      sodium_function :generichash_blake2b_init,
                      :crypto_generichash_blake2b_init_salt_personal,
                      %i[pointer pointer size_t size_t pointer pointer]

      sodium_function :generichash_blake2b_update,
                      :crypto_generichash_blake2b_update,
                      %i[pointer pointer ulong_long]

      sodium_function :generichash_blake2b_final,
                      :crypto_generichash_blake2b_final,
                      %i[pointer pointer size_t]

      EMPTY_PERSONAL = ("\0" * PERSONALBYTES).freeze
      EMPTY_SALT     = ("\0" * SALTBYTES).freeze

      # Calculate a Blake2b digest
      #
      # @param [String] message Message to be hashed
      # @param [Hash] options Blake2b configuration
      # @option opts [String]  :key for Blake2b keyed mode
      # @option opts [Integer] :digest_size size of output digest in bytes
      # @option opts [String]  :salt  Provide a salt to support randomised hashing.
      #                               This is mixed into the parameters block to start the hashing.
      # @option opts [Personal] :personal Provide personalisation string to allow pinning a hash for a particular purpose.
      #                                   This is mixed into the parameters block to start the hashing
      #
      # @raise [RbNaCl::LengthError] Invalid length specified for one or more options
      #
      # @return [String] Blake2b digest of the string as raw bytes
      def self.digest(message, options)
        opts = validate_opts(options)
        digest = Util.zeros(opts[:digest_size])
        generichash_blake2b(digest, opts[:digest_size], message, message.bytesize,
                            opts[:key], opts[:key_size], opts[:salt], opts[:personal]) ||
          raise(CryptoError, "Hashing failed!")
        digest
      end

      # Validate and sanitize values for Blake2b configuration
      #
      # @param [Hash] options Blake2b configuration
      # @option opts [String]  :key for Blake2b keyed mode
      # @option opts [Integer] :digest_size size of output digest in bytes
      # @option opts [String]  :salt  Provide a salt to support randomised hashing.
      #                               This is mixed into the parameters block to start the hashing.
      # @option opts [Personal] :personal Provide personalisation string to allow pinning a hash for a particular purpose.
      #                                   This is mixed into the parameters block to start the hashing
      #
      # @raise [RbNaCl::LengthError] Invalid length specified for one or more options
      #
      # @return [Hash] opts Configuration hash with sanitized values
      def self.validate_opts(opts)
        key = opts.fetch(:key, nil)
        if key
          key_size = key.bytesize
          raise LengthError, "key too short" if key_size < KEYBYTES_MIN
          raise LengthError, "key too long"  if key_size > KEYBYTES_MAX
        else
          key_size = 0
        end
        opts[:key_size] = key_size

        digest_size = opts.fetch(:digest_size, BYTES_MAX)
        raise LengthError, "digest size too short" if digest_size < BYTES_MIN
        raise LengthError, "digest size too long"  if digest_size > BYTES_MAX

        opts[:digest_size] = digest_size

        personal = opts.fetch(:personal, EMPTY_PERSONAL)
        opts[:personal] = Util.zero_pad(PERSONALBYTES, personal)

        salt = opts.fetch(:salt, EMPTY_SALT)
        opts[:salt] = Util.zero_pad(SALTBYTES, salt)
        opts
      end

      private_class_method :validate_opts

      def self.new(opts = {})
        opts = validate_opts(opts)
        super
      end

      # Create a new Blake2b hash object
      #
      # @param [Hash] opts Blake2b configuration
      # @option opts [String]  :key for Blake2b keyed mode
      # @option opts [Integer] :digest_size size of output digest in bytes
      # @option opts [String]  :salt  Provide a salt to support randomised hashing.
      #                               This is mixed into the parameters block to start the hashing.
      # @option opts [Personal] :personal Provide personalisation string to allow pinning a hash for a particular purpose.
      #                                   This is mixed into the parameters block to start the hashing
      #
      # @raise [RbNaCl::LengthError] Invalid length specified for one or more options
      #
      # @return [RbNaCl::Hash::Blake2b] A Blake2b hasher object
      def initialize(opts = {})
        @key         = opts[:key]
        @key_size    = opts[:key_size]
        @digest_size = opts[:digest_size]
        @personal    = opts[:personal]
        @salt        = opts[:salt]

        @incycle  = false
        @instate  = nil
      end

      # Initialize state for Blake2b hash calculation,
      # this will be called automatically from #update if needed
      def reset
        @instate.release if @instate
        @instate = State.new
        self.class.generichash_blake2b_init(@instate.pointer, @key, @key_size, @digest_size, @salt, @personal) ||
          raise(CryptoError, "Hash init failed!")
        @incycle = true
        @digest = nil
      end

      # Reentrant version of Blake2b digest calculation method
      #
      # @param [String] message Message to be hashed
      def update(message)
        reset unless @incycle
        self.class.generichash_blake2b_update(@instate.pointer, message, message.bytesize) ||
          raise(CryptoError, "Hashing failed!")
      end
      alias << update

      # Finalize digest calculation, return cached digest if any
      #
      # @return [String] Blake2b digest of the string as raw bytes
      def digest
        raise(CryptoError, "No message to hash yet!") unless @incycle
        return @digest if @digest

        @digest = Util.zeros(@digest_size)
        self.class.generichash_blake2b_final(@instate.pointer, @digest, @digest_size) ||
          raise(CryptoError, "Hash finalization failed!")
        @digest
      end

      # The crypto_generichash_blake2b_state struct representation
      # ref: jedisct1/libsodium/blob/c87df74c7b5969f4/src/libsodium/include/sodium/crypto_generichash_blake2b.h#L23-L25
      class State < FFI::Struct
        layout :opaque, [:uint8, 384]
      end
    end
  end
end
