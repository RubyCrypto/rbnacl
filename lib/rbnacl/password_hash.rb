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
  # subsitutes)
  #
  # All of them also take a CPU work factor, which increases the amount of
  # computation needed to produce the digest.
  module PasswordHash
    # scrypt: the original sequential memory hard password hashing function.
    # This is also the only password hashing function supported by libsodium,
    # but that's okay, because it's pretty awesome.
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
  end
end
