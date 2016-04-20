# encoding: binary
module RbNaCl
  module PasswordHash
    # The scrypt sequential memory hard password hashing function
    #
    # scrypt is a password hash (or password based KDF). That is to say, where
    # most hash functions are designed to be fast because hashing is often a
    # bottleneck, scrypt is slow by design, because it's trying to "strengthen"
    # the password by combining it with a random "salt" value then perform a
    # series of operation on the result which are slow enough to defeat
    # brute-force password cracking attempts.
    #
    # scrypt is similar to the bcrypt and pbkdf2 password hashes in that it's
    # designed to strengthen passwords, but includes a new design element
    # called "sequential memory hardness" which helps defeat attempts by
    # attackers to compensate for their lack of memory (since they're typically
    # on GPUs or FPGAs) with additional computation.
    class SCrypt
      extend Sodium
      sodium_type :pwhash
      sodium_primitive :scryptsalsa208sha256

      sodium_constant :SALTBYTES

      sodium_function :scrypt,
                      :crypto_pwhash_scryptsalsa208sha256,
                      [:pointer, :ulong_long, :pointer, :ulong_long, :pointer, :ulong_long, :size_t]

      # Create a new SCrypt password hash object
      #
      # @param [Integer] opslimit the CPU cost (e.g. 2**20)
      # @param [Integer] memlimit the memory cost (e.g. 2**24)
      #
      # @return [RbNaCl::PasswordHash::SCrypt] An SCrypt password hasher object
      def initialize(opslimit, memlimit, digest_size = 64)
        # TODO: sanity check these parameters
        @opslimit = opslimit
        @memlimit = memlimit

        # TODO: check digest size validity
        # raise LengthError, "digest size too short" if @digest_size < BYTES_MIN
        # raise LengthError, "digest size too long"  if @digest_size > BYTES_MAX

        @digest_size = digest_size
      end

      # Calculate an scrypt digest for a given password and salt
      #
      # @param [String] password to be hashed
      # @param [String] salt to make the digest unique
      #
      # @return [String] scrypt digest of the string as raw bytes
      def digest(password, salt)
        digest = Util.zeros(@digest_size)
        salt   = Util.check_string(salt, SALTBYTES, "salt")

        self.class.scrypt(digest, @digest_size, password, password.bytesize, salt, @opslimit, @memlimit) || raise(CryptoError, "scrypt failed!")
        digest
      end
    end
  end
end
