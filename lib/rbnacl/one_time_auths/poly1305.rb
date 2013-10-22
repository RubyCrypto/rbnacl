# encoding: binary
module RbNaCl
  module OneTimeAuths
    # Computes an authenticator using poly1305
    #
    # The authenticator can be used at a later time to verify the provenance of
    # the message by recomputing the tag over the message and then comparing it to
    # the provided authenticator.  The class provides methods for generating
    # signatures and also has a constant-time implementation for checking them.
    #
    # As the name suggests, this is a **ONE TIME** authenticator.  Computing an
    # authenticator for two messages using the same key probably gives an
    # attacker enough information to forge further authenticators for the same
    # key.
    #
    # This is a secret key authenticator, i.e. anyone who can verify signatures
    # can also create them.
    #
    # @see http://nacl.cr.yp.to/onetimeauth.html
    class Poly1305 < Auth
      extend Sodium

      sodium_type      :onetimeauth
      sodium_primitive :poly1305
      sodium_constant  :BYTES
      sodium_constant  :KEYBYTES

      sodium_function :onetimeauth_poly1305,
                      :crypto_onetimeauth_poly1305,
                      [:pointer, :pointer, :ulong_long, :pointer]

      sodium_function :onetimeauth_poly1305_verify,
                      :crypto_onetimeauth_poly1305_verify,
                      [:pointer, :pointer, :ulong_long, :pointer]

      private
      def compute_authenticator(authenticator, message)
        self.class.onetimeauth_poly1305(authenticator, message, message.bytesize, key)
      end

      def verify_message(authenticator, message)
        self.class.onetimeauth_poly1305_verify(authenticator, message, message.bytesize, key)
      end

    end
  end
end
