# encoding: binary
# frozen_string_literal: true

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

    # argon2: state of the art in the design of memory-hard hashing functions
    # (default digest algorithm).
    #
    # @param [String] password to be hashed
    # @param [String] salt to make the digest unique
    # @param [Integer] opslimit the CPU cost (3..10)
    # @param [Integer] memlimit the memory cost, in bytes
    # @param [Integer] digest_size of the output
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The argon2 digest as raw bytes
    def self.argon2(password, salt, opslimit, memlimit, digest_size = 64)
      argon2_supported? && Argon2.new(opslimit, memlimit, digest_size).digest(password, salt)
    end

    # argon2i: argon2, using argon2i digest algorithm.
    #
    # @param [String] password to be hashed
    # @param [String] salt to make the digest unique
    # @param [Integer] opslimit the CPU cost (3..10)
    # @param [Integer] memlimit the memory cost, in bytes
    # @param [Integer] digest_size of the output
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The argon2i digest as raw bytes
    def self.argon2i(password, salt, opslimit, memlimit, digest_size = 64)
      argon2_supported? && Argon2.new(opslimit, memlimit, digest_size).digest(password, salt, :argon2i)
    end

    # argon2id: argon2, using argon2id digest algorithm.
    #
    # @param [String] password to be hashed
    # @param [String] salt to make the digest unique
    # @param [Integer] opslimit the CPU cost (3..10)
    # @param [Integer] memlimit the memory cost, in bytes
    # @param [Integer] digest_size of the output
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The argon2id digest as raw bytes
    def self.argon2id(password, salt, opslimit, memlimit, digest_size = 64)
      argon2_supported? && Argon2.new(opslimit, memlimit, digest_size).digest(password, salt, :argon2id)
    end

    # argon2_str: crypt-style password digest
    #
    # @param [String] password to be hashed
    # @param [Integer] opslimit the CPU cost (3..10)
    # @param [Integer] memlimit the memory cost, in bytes
    #
    # @raise [CryptoError] If calculating the digest fails for some reason.
    #
    # @return [String] The argon2i digest as crypt-style string
    def self.argon2_str(password, opslimit = :interactive, memlimit = :interactive)
      argon2_supported? && Argon2.new(opslimit, memlimit).digest_str(password)
    end

    # argon2_valid?: verify crypt-style password digest
    #
    # @param [String] password to verify
    # @param [String] str_digest to verify
    #
    # @return [Boolean] true if digest was created using password
    def self.argon2_valid?(password, str_digest)
      argon2_supported? && Argon2.digest_str_verify(password, str_digest)
    end

    class << self
      protected

      def argon2_supported?
        if RbNaCl::Sodium::Version::ARGON2_SUPPORTED
          true
        else
          raise NotImplementedError, "argon2 requires libsodium version >= 1.0.9" \
                                     " (currently running #{RbNaCl::Sodium::Version::STRING})"
        end
      end
    end
  end
end
