# encoding: binary
module RbNaCl
  # Password hashing functions
  #
  # These hash functions are designed specifically for the purposes of securely
  # storing passwords in a way that they can be checked against a supplied
  # password but an attacker who obtains a hash cannot easily reverse them back
  # into the original password.
  #
  # Unlike normal hash functions, which are intentionally designed to hash data
  # as quickly as they can while remaining secure, password hashing functions
  # are intentionally designed to be slow so they are hard for attackers to
  # brute force.
  #
  # All password hashing functions take a "salt" value which should be randomly
  # generated on a per-password basis (using RbNaCl::Random, accept no
  # substitutes)
  #
  # All of them also take a CPU work factor, which increases the amount of
  # computation needed to produce the digest.
  module PasswordHash
    # scrypt: the original sequential memory-hard password hashing function.
    #
    # @param [String] password to be hashed
    # @param [String] salt to make the digest unique
    # @param [Integer] opslimit the CPU cost (e.g. 2**20)
    # @param [Integer] memlimit the memory cost (e.g. 2**24)
    # @param [Integer] digest_size of the output
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The scrypt digest as raw bytes
    def self.scrypt(password, salt, opslimit, memlimit, digest_size = 64)
      SCrypt.new(opslimit, memlimit, digest_size).digest(password, salt)
    end

    # argon2: state of the art in the design of memory-hard hashing functions.
    #
    # @param [String] password to be hashed
    # @param [String] salt to make the digest unique
    # @param [Integer] opslimit the CPU cost (1..10)
    # @param [Integer] memlimit the memory cost, in bytes
    # @param [Integer] digest_size of the output
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The scrypt digest as raw bytes
    def self.argon2(password, salt, opslimit, memlimit, digest_size = 64)
      if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
        Argon2.new(opslimit, memlimit, digest_size).digest(password, salt)
      else
        raise NoMethodError, "argon2 requires libsodium version >= 1.0.9" \
                             " (currently running #{RbNaCl::Sodium::Version::STRING})"
      end
    end
  end
end
