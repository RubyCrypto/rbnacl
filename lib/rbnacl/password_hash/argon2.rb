# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module PasswordHash
    # Since version 1.0.9, Sodium provides a password hashing scheme called
    # Argon2. Argon2 summarizes the state of the art in the design of memory-
    # hard functions. It aims at the highest memory filling rate and effective
    # use of multiple computing units, while still providing defense against
    # tradeoff attacks. It prevents ASICs from having a significant advantage
    # over software implementations.
    class Argon2
      extend Sodium

      sodium_type :pwhash
      sodium_primitive :argon2i

      sodium_type_primitive_constant :ALG_ARGON2I13
      sodium_type_primitive_constant :SALTBYTES
      sodium_type_primitive_constant :STRBYTES
      sodium_type_primitive_constant :OPSLIMIT_INTERACTIVE  # 4
      sodium_type_primitive_constant :MEMLIMIT_INTERACTIVE  # 2 ** 25 (32mb)
      sodium_type_primitive_constant :OPSLIMIT_MODERATE     # 6
      sodium_type_primitive_constant :MEMLIMIT_MODERATE     # 2 ** 27 (128mb)
      sodium_type_primitive_constant :OPSLIMIT_SENSITIVE    # 8
      sodium_type_primitive_constant :MEMLIMIT_SENSITIVE    # 2 ** 29 (512mb)

      ARGON2_MIN_OUTLEN = 16
      ARGON2_MAX_OUTLEN = 0xFFFFFFFF

      MEMLIMIT_MIN = 8192
      MEMLIMIT_MAX = 4_294_967_296
      OPSLIMIT_MIN = 3
      OPSLIMIT_MAX = 10

      sodium_function_with_return_code(
        :pwhash,
        :crypto_pwhash_argon2i,
        %i[pointer ulong_long pointer ulong_long pointer ulong_long size_t int]
      )

      sodium_function(
        :pwhash_str,
        :crypto_pwhash_argon2i_str,
        %i[pointer pointer ulong_long ulong_long size_t]
      )

      sodium_function(
        :pwhash_str_verify,
        :crypto_pwhash_argon2i_str_verify,
        %i[pointer pointer ulong_long]
      )

      ALG_DEFAULT = ALG_ARGON2I13

      ARGON_ERROR_CODES = {
        -1 => "ARGON2_OUTPUT_PTR_NULL", -2 => "ARGON2_OUTPUT_TOO_SHORT",
        -3 => "ARGON2_OUTPUT_TOO_LONG", -4 => "ARGON2_PWD_TOO_SHORT",
        -5 => "ARGON2_PWD_TOO_LONG", -6 => "ARGON2_SALT_TOO_SHORT",
        -7 => "ARGON2_SALT_TOO_LONG", -8 => "ARGON2_AD_TOO_SHORT",
        -9 => "ARGON2_AD_TOO_LONG", -10 => "ARGON2_SECRET_TOO_SHORT",
        -11 => "ARGON2_SECRET_TOO_LONG", -12 => "ARGON2_TIME_TOO_SMALL",
        -13 => "ARGON2_TIME_TOO_LARGE", -14 => "ARGON2_MEMORY_TOO_LITTLE",
        -15 => "ARGON2_MEMORY_TOO_MUCH", -16 => "ARGON2_LANES_TOO_FEW",
        -17 => "ARGON2_LANES_TOO_MANY", -18 => "ARGON2_PWD_PTR_MISMATCH",
        -19 => "ARGON2_SALT_PTR_MISMATCH", -20 => "ARGON2_SECRET_PTR_MISMATCH",
        -21 => "ARGON2_AD_PTR_MISMATCH", -22 => "ARGON2_MEMORY_ALLOCATION_ERROR",
        -23 => "ARGON2_FREE_MEMORY_CBK_NULL", -24 => "ARGON2_ALLOCATE_MEMORY_CBK_NULL",
        -25 => "ARGON2_INCORRECT_PARAMETER", -26 => "ARGON2_INCORRECT_TYPE",
        -27 => "ARGON2_OUT_PTR_MISMATCH", -28 => "ARGON2_THREADS_TOO_FEW",
        -29 => "ARGON2_THREADS_TOO_MANY", -30 => "ARGON2_MISSING_ARGS",
        -31 => "ARGON2_ENCODING_FAIL", -32 => "ARGON2_DECODING_FAIL",
        -33 => "ARGON2_THREAD_FAIL", -34 => "ARGON2_DECODING_LENGTH_FAIL",
        -35 => "ARGON2_VERIFY_MISMATCH"
      }.freeze

      # Create a new Argon2 password hash object
      #
      # opslimit and memlimit may be an integer, or one of the following
      # symbols:
      #
      # [:interactive] Suitable for interactive online operations. This
      #                requires 32 Mb of dedicated RAM.
      # [:moderate] A compromise between interactive and sensitive. This
      #             requires 128 Mb of dedicated RAM, and takes about 0.7
      #             seconds on a 2.8 Ghz Core i7 CPU.
      # [:sensitive] For highly sensitive and non-interactive operations. This
      #              requires 128 Mb of dedicated RAM, and takes about 0.7
      #              seconds on a 2.8 Ghz Core i7 CPU
      #
      # @param [Integer] opslimit the CPU cost (1..10)
      # @param [Integer] memlimit the memory cost (e.g. 2**24)
      # @param [Integer] digest_size the byte length of the resulting digest
      #
      # @return [RbNaCl::PasswordHash::Argon2] An Argon2 password hasher object
      def initialize(opslimit, memlimit, digest_size = nil)
        @opslimit    = self.class.opslimit_value(opslimit)
        @memlimit    = self.class.memlimit_value(memlimit)
        @digest_size = self.class.digest_size_value(digest_size) if digest_size
      end

      # Calculate an Argon2 digest for a given password and salt
      #
      # @param [String] password to be hashed
      # @param [String] salt to make the digest unique
      #
      # @return [String] scrypt digest of the string as raw bytes
      def digest(password, salt)
        raise ArgumentError, "digest_size is required" unless @digest_size
        digest = Util.zeros(@digest_size)
        salt   = Util.check_string(salt, SALTBYTES, "salt")

        status = self.class.pwhash(
          digest, @digest_size,
          password, password.bytesize, salt,
          @opslimit, @memlimit, ALG_DEFAULT
        )
        raise CryptoError, ARGON_ERROR_CODES[status] if status.nonzero?
        digest
      end

      # Calculate an Argon2 digest in the form of a crypt-style string.
      # The resulting string encodes the parameters and salt.
      #
      # @param [String] password to be hashed
      #
      # @return [String] argon2 digest string
      def digest_str(password)
        raise ArgumentError, "password must be a String" unless password.is_a?(String)
        result = Util.zeros(STRBYTES)

        ok = self.class.pwhash_str(
          result,
          password, password.bytesize,
          @opslimit, @memlimit
        )
        raise CryptoError, "unknown error in Argon2#digest_str" unless ok
        result.delete("\x00")
      end

      # Compares a password with a digest string
      #
      # @param [String] password to be hashed
      # @param [String] digest_string to compare to
      #
      # @return [boolean] true if password matches digest_string
      def self.digest_str_verify(password, digest_string)
        raise ArgumentError, "password must be a String" unless password.is_a?(String)
        raise ArgumentError, "digest_string must be a String" unless digest_string.is_a?(String)
        pwhash_str_verify(
          digest_string,
          password, password.bytesize
        )
      end

      # Clamps opslimit to an acceptable range (3..10)
      #
      # @param [Integer] opslimit value to be checked
      #
      # @raise [ArgumentError] if the value is out of range
      #
      # @return [Integer] opslimit a valid value for opslimit
      def self.opslimit_value(opslimit)
        case opslimit
        when :interactive then OPSLIMIT_INTERACTIVE
        when :moderate then OPSLIMIT_MODERATE
        when :sensitive then OPSLIMIT_SENSITIVE
        when OPSLIMIT_MIN..OPSLIMIT_MAX then opslimit.to_i
        else
          raise ArgumentError, "opslimit must be within the range 3..10"
        end
      end

      # Clamps memlimit between 8192 bytes and 4 TB (eg. 2**32)
      #
      # @param [Integer] memlimit, in bytes
      #
      # @raise [ArgumentError] if the value is out of range
      #
      # @return [Integer] memlimit a valid value for memlimit
      def self.memlimit_value(memlimit)
        case memlimit
        when :interactive then MEMLIMIT_INTERACTIVE
        when :moderate then MEMLIMIT_MODERATE
        when :sensitive then MEMLIMIT_SENSITIVE
        when MEMLIMIT_MIN..MEMLIMIT_MAX then memlimit.to_i
        else
          raise ArgumentError, "memlimit must be within the range 2**(13..32)"
        end
      end

      # Clamps digest size between 16..4294967295
      #
      # @raise [LengthError] if the value is out of range
      #
      # @return [Integer] digest_size a valid value for digest size
      def self.digest_size_value(digest_size)
        digest_size = digest_size.to_i
        raise LengthError, "digest size too short" if digest_size < ARGON2_MIN_OUTLEN
        raise LengthError, "digest size too long"  if digest_size > ARGON2_MAX_OUTLEN
        digest_size
      end
    end
  end
end
