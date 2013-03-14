# encoding: binary
module Crypto
  class SecretBox
    # The XSalsa20Poly1305 class boxes and unboxes messages
    #
    # This class uses the given secret key to encrypt and decrypt messages.
    #
    # It is VITALLY important that the nonce is a nonce, i.e. it is a number
    # used only once for any given pair of keys.  If you fail to do this, you
    # compromise the privacy of the messages encrypted. Give your nonces a
    # different prefix, or have one side use an odd counter and one an even
    # counter.  Just make sure they are different.
    #
    # The ciphertexts generated by this class include a 16-byte authenticator
    # which is checked as part of the decryption.  An invalid authenticator
    # will cause the unbox function to raise.  The authenticator is not a
    # signature.  Once you've looked in the box, you've demonstrated the
    # ability to create arbitrary valid messages, so messages you send are
    # repudiatable.  For non-repudiatable messages, sign them before or after
    # encryption.
    #
    # * Encryption: XSalsa20, a fast stream cipher primitive
    # * Authentication: Poly1305, a fast one time authentication primitive
    #
    # **WARNING**: This class provides direct access to a low-level
    # cryptographic method.  You should not use this class without good reason
    # and instead use the Crypto::SecretBox box class which will always point
    # to the best primitive the library provides bindings for.  It also
    # provides a nicer interface, with e.g. decoding of ascii-encoded keys.
    class XSalsa20Poly1305
      # Number of bytes for a secret key
      KEYBYTES   = NaCl::XSALSA20_POLY1305_SECRETBOX_KEYBYTES
      # Number of bytes for a nonce
      NONCEBYTES = NaCl::XSALSA20_POLY1305_SECRETBOX_NONCEBYTES

      # Create a new SecretBox
      #
      # Sets up the Box with a secret key fro encrypting and decrypting messages.
      #
      # @param key [String] The key to encrypt and decrypt with
      #
      # @raise [Crypto::LengthError] on invalid keys
      #
      # @return [Crypto::SecretBox] The new Box, ready to use
      def initialize(key)
        @key = key
        Util.check_length(@key, KEYBYTES, "Secret key")
      end

      # Returns the primitive name
      #
      # @return [Symbol] the primitive name
      def self.primitive
        :xsalsa20_poly1305
      end

      # Returns the primitive name
      #
      # @return [Symbol] the primitive name
      def primitive
        self.class.primitive
      end

      # returns the number of bytes in a nonce
      #
      # @return [Integer] Number of nonce bytes
      def nonce_bytes
        NONCEBYTES
      end


      # Encrypts a message
      #
      # Encrypts the message with the given nonce to the key set up when
      # initializing the class.  Make sure the nonce is unique for any given
      # key, or you might as well just send plain text.
      #
      # This function takes care of the padding required by the NaCL C API.
      #
      # @param nonce [String] A 24-byte string containing the nonce.
      # @param message [String] The message to be encrypted.
      #
      # @raise [Crypto::LengthError] If the nonce is not valid
      #
      # @return [String] The ciphertext without the nonce prepended (BINARY encoded)
      def box(nonce, message)
        Util.check_length(nonce, NONCEBYTES, "Nonce")
        msg = Util.prepend_zeros(NaCl::ZEROBYTES, message)
        ct  = Util.zeros(msg.bytesize)

        NaCl.crypto_secretbox_xsalsa20poly1305(ct, msg, msg.bytesize, nonce, @key) || raise(CryptoError, "Encryption failed")
        Util.remove_zeros(NaCl::BOXZEROBYTES, ct)
      end
      alias encrypt box

      # Decrypts a ciphertext
      #
      # Decrypts the ciphertext with the given nonce using the key setup when
      # initializing the class.
      #
      # This function takes care of the padding required by the NaCL C API.
      #
      # @param nonce [String] A 24-byte string containing the nonce.
      # @param ciphertext [String] The message to be decrypted.
      #
      # @raise [Crypto::LengthError] If the nonce is not valid
      # @raise [Crypto::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The decrypted message (BINARY encoded)
      def open(nonce, ciphertext)
        Util.check_length(nonce, NONCEBYTES, "Nonce")
        ct = Util.prepend_zeros(NaCl::BOXZEROBYTES, ciphertext)
        message  = Util.zeros(ct.bytesize)

        NaCl.crypto_secretbox_xsalsa20poly1305_open(message, ct, ct.bytesize, nonce, @key) || raise(CryptoError, "Decryption failed. Ciphertext failed verification.")
        Util.remove_zeros(NaCl::ZEROBYTES, message)
      end
      alias decrypt open
    end
  end
end
