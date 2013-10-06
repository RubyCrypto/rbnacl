# encoding: binary
module RbNaCl
  module HMAC
    # Computes an authenticator as HMAC-SHA-256
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
    class SHA256 < Auth
      extend Sodium

      sodium_type      :auth
      sodium_primitive :hmacsha256
      sodium_constant  :BYTES
      sodium_constant  :KEYBYTES

      sodium_function  :auth_hmacsha256,
                       :crypto_auth_hmacsha256,
                       [:pointer, :pointer, :ulong_long, :pointer]
      
      sodium_function  :auth_hmacsha256_verify,
                       :crypto_auth_hmacsha256_verify,
                       [:pointer, :pointer, :ulong_long, :pointer]
      
      private
      def compute_authenticator(authenticator, message)
        self.class.auth_hmacsha256(authenticator, message, message.bytesize, key)
      end

      def verify_message(authenticator, message)
        self.class.auth_hmacsha256_verify(authenticator, message, message.bytesize, key)
      end
    end
  end
end
