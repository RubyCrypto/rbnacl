# encoding: binary
require 'forwardable'
module RbNaCl
  # The simplest nonce strategy that could possibly work
  #
  # This class implements the simplest possible nonce generation strategy to
  # wrap a RbNaCl::Box or RbNaCl::SecretBox.  A 24-byte random nonce is used
  # for the encryption and is prepended to the message.  When it is time to
  # open the box, the message is split into nonce and ciphertext, and then the
  # box is decrypted.
  #
  # Thanks to the size of the nonce, the chance of a collision is negligible.  For
  # example, after encrypting 2^64 messages, the odds of their having been
  # repeated nonce is approximately 2^-64.  As an additional convenience, the
  # ciphertexts may be encoded or decoded by any of the encoders implemented in
  # the library.
  #
  # The resulting ciphertexts are 40 bytes longer than the plain text (24 byte
  # nonce plus a 16 byte authenticator).  This might be annoying if you're
  # encrypting tweets, but for files represents a fairly small overhead.
  #
  # Some caveats:
  #
  # * If your random source is broken, so is the security of the messages.  You
  #   have bigger problems than just this library at that point, but it's worth
  #   saying.
  # * The confidentiality of your messages is assured with this strategy, but
  #   there is no protection against messages being reordered and replayed by an
  #   active adversary.
  class SimpleBox
    extend Forwardable
    def_delegators :@box, :nonce_bytes, :primitive

    # Create a new RandomNonceBox
    #
    # @param box [SecretBox, Box] the SecretBox or Box to use.
    #
    # @return [RandomNonceBox] Ready for use
    def initialize(box)
      @box = box
    end

    # Use a secret key to create a RandomNonceBox
    #
    # This is a convenience method.  It takes a secret key and instantiates a
    # SecretBox under the hood, then returns the new RandomNonceBox.
    #
    # @param secret_key [String] The secret key, 32 bytes long.
    #
    # @return [RandomNonceBox] Ready for use
    def self.from_secret_key(secret_key)
      new(SecretBox.new(secret_key))
    end

    # Use a pair of keys to create a RandomNonceBox
    #
    # This is a convenience method.  It takes a pair of keys and instantiates a
    # Box under the hood, then returns the new RandomNonceBox.
    #
    # @param public_key  [PublicKey,  String] The RbNaCl public key, as class or string
    # @param private_key [PrivateKey, String] The RbNaCl private key, as class or string
    #
    # @return [RandomNonceBox] Ready for use
    def self.from_keypair(public_key, private_key)
      new(Box.new(public_key, private_key))
    end

    # Encrypts the message with a random nonce
    #
    # Encrypts the message with a random nonce, then returns the ciphertext with
    # the nonce prepended.  Optionally encodes the message using an encoder.
    #
    # @param message [String] The message to encrypt
    #
    # @return [String] The enciphered message
    def box(message)
      nonce = generate_nonce
      cipher_text = @box.box(nonce, message)
      nonce + cipher_text
    end
    alias encrypt box

    # Decrypts the ciphertext with a random nonce
    #
    # Takes a ciphertext, optionally decodes it, then splits the nonce off the
    # front and uses this to decrypt.  Returns the message.
    #
    # @param enciphered_message [String] The message to decrypt.
    #
    # @raise [CryptoError] If the message has been tampered with.
    #
    # @return [String] The decoded message
    def open(enciphered_message)
      nonce, ciphertext = extract_nonce(enciphered_message.to_s)
      @box.open(nonce, ciphertext)
    end
    alias decrypt open

    private
    def generate_nonce
      Random.random_bytes(nonce_bytes)
    end

    def extract_nonce(bytes)
      nonce = bytes.slice(0, nonce_bytes)
      [nonce, bytes.slice(nonce_bytes..-1)]
    end
  end

  # Backwards compatibility with the old RandomNonceBox name
  RandomNonceBox = SimpleBox
end
