# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module HMAC
    # Computes an authenticator as HMAC-SHA-512 truncated to 256-bits
    #
    # The authenticator can be used at a later time to verify the provenance of
    # the message by recomputing the HMAC over the message and then comparing it to
    # the provided authenticator.  The class provides methods for generating
    # signatures and also has a constant-time implementation for checking them.
    #
    # This is a secret key authenticator, i.e. anyone who can verify signatures
    # can also create them.
    #
    # @see http://nacl.cr.yp.to/auth.html
    class SHA512256 < Auth
      extend Sodium

      sodium_type :auth
      sodium_primitive :hmacsha512256
      sodium_constant :BYTES
      sodium_constant :KEYBYTES

      sodium_function :auth_hmacsha512256_init,
                      :crypto_auth_hmacsha512256_init,
                      %i[pointer pointer size_t]

      sodium_function :auth_hmacsha512256_update,
                      :crypto_auth_hmacsha512256_update,
                      %i[pointer pointer ulong_long]

      sodium_function :auth_hmacsha512256_final,
                      :crypto_auth_hmacsha512256_final,
                      %i[pointer pointer]

      # Create instance without checking key length
      #
      # RFC 2104 HMAC
      # The key for HMAC can be of any length.
      #
      # see https://tools.ietf.org/html/rfc2104#section-3
      def initialize(key)
        @key = Util.check_hmac_key(key, "#{self.class} key")
        @state = State.new
        @authenticator = Util.zeros(tag_bytes)

        self.class.auth_hmacsha512256_init(@state, key, key.bytesize)
      end

      # Compute authenticator for message
      #
      # @params [#to_str] message message to construct an authenticator for
      def update(message)
        self.class.auth_hmacsha512256_update(@state, message, message.bytesize)
        self.class.auth_hmacsha512256_final(@state.clone, @authenticator)

        hexdigest
      end

      # Return the authenticator, as raw bytes
      #
      # @return [String] The authenticator, as raw bytes
      def digest
        @authenticator
      end

      # Return the authenticator, as hex string
      #
      # @return [String] The authenticator, as hex string
      def hexdigest
        @authenticator.unpack("H*").last
      end

      private

      def compute_authenticator(authenticator, message)
        state = State.new

        self.class.auth_hmacsha512256_init(state, key, key.bytesize)
        self.class.auth_hmacsha512256_update(state, message, message.bytesize)
        self.class.auth_hmacsha512256_final(state, authenticator)
      end

      def verify_message(authenticator, message)
        correct = Util.zeros(BYTES)
        compute_authenticator(correct, message)
        Util.verify32(correct, authenticator)
      end

      # The crypto_auth_hmacsha512256_state struct representation
      # ref: jedisct1/libsodium/src/libsodium/include/sodium/crypto_auth_hmacsha512256.h
      class SHA512256State < FFI::Struct
        layout :state, [:uint64, 8],
               :count, [:uint64, 2],
               :buf, [:uint8, 128]
      end

      # The crypto_hash_sha512_state struct representation
      # ref: jedisct1/libsodium/src/libsodium/include/sodium/crypto_hash_sha512.h
      class State < FFI::Struct
        layout :ictx, SHA512256State,
               :octx, SHA512256State
      end
    end
  end
end
