# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module Boxes
    # Sealed boxes are designed to anonymously send messages to a recipient
    # given its public key.
    #
    # Only the recipient can decrypt these messages, using its private key.
    # While the recipient can verify the integrity of the message, it cannot
    # verify the identity of the sender.
    #
    # A message is encrypted using an ephemeral key pair, whose secret part
    # is destroyed right after the encryption process.
    #
    # Without knowing the secret key used for a given message, the sender
    # cannot decrypt its own message later. And without additional data,
    # a message cannot be correlated with the identity of its sender.
    class Sealed
      extend Sodium

      sodium_type      :box
      sodium_constant  :SEALBYTES
      sodium_primitive :curve25519xsalsa20poly1305

      sodium_function :box_seal,
                      :crypto_box_seal,
                      %i[pointer pointer ulong_long pointer]

      sodium_function :box_seal_open,
                      :crypto_box_seal_open,
                      %i[pointer pointer ulong_long pointer pointer]

      # WARNING: you should strongly prefer the from_private_key/from_public_key class methods.
      #
      # Create a new Sealed Box
      #
      # Sets up the Box for deriving the shared key and encrypting and
      # decrypting messages.
      #
      # @param public_key [String,RbNaCl::PublicKey] The public key to encrypt to
      # @param private_key [String,RbNaCl::PrivateKey] The private key to decrypt with
      #
      # @raise [RbNaCl::LengthError] on invalid keys
      #
      # @return [RbNaCl::SealedBox] The new Box, ready to use
      def initialize(public_key, private_key = nil)
        unless private_key.nil?
          @private_key = private_key.is_a?(PrivateKey) ? private_key : PrivateKey.new(private_key)
          raise IncorrectPrimitiveError unless @private_key.primitive == primitive

          public_key = @private_key.public_key if public_key.nil?
        end

        @public_key = public_key.is_a?(PublicKey) ? public_key : PublicKey.new(public_key)
        raise IncorrectPrimitiveError unless @public_key.primitive == primitive
      end

      # Create a new Sealed Box for encrypting
      #
      # Sets up the Box for encryoption of new messages.
      #
      # @param private_key [String,RbNaCl::PrivateKey] The private key to decrypt with
      #
      # @raise [RbNaCl::LengthError] on invalid keys
      #
      # @return [RbNaCl::SealedBox] The new Box, ready to use
      def self.from_private_key(private_key)
        new(nil, private_key)
      end

      # Create a new Sealed Box for decrypting
      #
      # Sets up the Box for decrytoption of new messages.
      #
      # @param public_key [String,RbNaCl::PublicKey] The public key to encrypt to
      #
      # @raise [RbNaCl::LengthError] on invalid keys
      #
      # @return [RbNaCl::SealedBox] The new Box, ready to use
      def self.from_public_key(public_key)
        new(public_key, nil)
      end

      # Encrypts a message
      #
      # @param message [String] The message to be encrypted.
      #
      # @raise [RbNaCl::CryptoError] If the encrytion fails.
      #
      # @return [String] The ciphertext (BINARY encoded)
      def box(message)
        # No padding needed.
        msg = message # variable name to match other RbNaCl code.
        # ensure enough space in result
        ct  = Util.zeros(msg.bytesize + SEALBYTES)

        success = self.class.box_seal(ct, msg, msg.bytesize, @public_key.to_s)
        raise CryptoError, "Encryption failed" unless success

        ct
      end
      alias encrypt box

      # Decrypts a ciphertext
      #
      # @param ciphertext [String] The message to be decrypted.
      #
      # @raise [RbNaCl::CryptoError] If no private key is available.
      # @raise [RbNaCl::CryptoError] If the ciphertext cannot be authenticated.
      #
      # @return [String] The decrypted message (BINARY encoded)
      def open(ciphertext)
        raise CryptoError, "Decryption failed. No private key." unless @private_key

        ct = ciphertext
        raise CryptoError, "Decryption failed. Ciphertext failed verification." if ct.bytesize < SEALBYTES

        message = Util.zeros(ct.bytesize - SEALBYTES)

        success = self.class.box_seal_open(message, ct, ct.bytesize, @public_key.to_s, @private_key.to_s)
        raise CryptoError, "Decryption failed. Ciphertext failed verification." unless success

        message
      end
      alias decrypt open

      # The crypto primitive for the box class
      #
      # @return [Symbol] The primitive used
      def primitive
        self.class.primitive
      end
    end
  end
end
