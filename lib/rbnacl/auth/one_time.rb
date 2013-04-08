# encoding: binary
module Crypto
  class Auth
    # Computes an authenticator using poly1305
    #
    # The authenticator can be used at a later time to verify the provenence of
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
    class OneTime < self
      # Number of bytes in a valid key
      KEYBYTES = NaCl::ONETIME_KEYBYTES

      # Number of bytes in a valid authenticator
      BYTES = NaCl::ONETIME_BYTES
      
      # The crypto primitive for the Auth::OneTime class
      #
      # @return [Symbol] The primitive used
      def self.primitive
        :poly_1305
      end

      private
      def compute_authenticator(message, authenticator)
        NaCl.crypto_auth_onetime(authenticator, message, message.bytesize, key)
      end

      def verify_message(message, authenticator)
        NaCl.crypto_auth_onetime_verify(authenticator, message, message.bytesize, key)
      end

    end
  end
end
