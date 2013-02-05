![RbNaCl](https://raw.github.com/cryptosphere/rbnacl/master/logo.png)
======
[![Build Status](https://travis-ci.org/cryptosphere/rbnacl.png?branch=master)](https://travis-ci.org/cryptosphere/rbnacl)

A Ruby binding to the state-of-the-art [Networking and Cryptography][nacl]
library by Daniel J. Bernstein. This is **NOT** Google Native Client. This
is a crypto library.

On a completely unrelated topic, RbNaCl is also the empirical formula for
Rubidium Sodium Chloride.

Need help with RbNaCl? Join the [RbNaCl Google Group][group]

[nacl]: http://nacl.cr.yp.to/
[group]: http://groups.google.com/group/rbnacl

## Why NaCl?

NaCl is a different kind of cryptographic library. In the past crypto
libraries were kitchen sinks of little bits and pieces, like ciphers,
MACs, signature algorithms, and hash functions. To accomplish anything
you had to make a lot of decisions about which specific pieces to use,
and if any of your decisions were wrong, the result was an insecure
system. The choices are also not easy: EAX? GCM? CCM? AES-CTR? CMAC?
OMAC1? AEAD? NIST? CBC? CFB? CTR? ECB? OMGWTFBBQ!

NaCl puts cryptography on Rails! Instead of making you choose which
cryptographic primitives to use, NaCl provides convention over configuration
in the form of expertly-assembled high-level cryptographic APIs that ensure
not only the confidentiality of your data, but also detect tampering.
These high-level, easy-to-use APIs are designed to be hard to attack by
default in ways primitives exposed by libraries like OpenSSL are not.

This approach makes NaCl a lot closer to a system like GPG than it is
to the cryptographic primitive APIs in a library like OpenSSL. In addition,
NaCl also uses state-of-the-art encryption, including Curve25519 elliptic
curves and the XSalsa20 stream cipher. This means with NaCl you not only get
a system which is designed to be secure-by-default, you also get one which
is extremely fast with comparatively small cryptographic keys.

## Supported platforms

You can use RbNaCl anywhere you can get libsodium installed (see below).
RbNaCl is continuously integration tested on the following Ruby VMs:

* MRI 1.8 / REE
* MRI 1.9 (YARV)
* JRuby 1.7 (in both 1.8/1.9 mode)
* Rubinius HEAD (in both 1.8/1.9 mode)

In theory Windows should be supported, although there are not yet any
reports of successful Windows users.

## Installation

RbNaCl is implemented as a Ruby FFI binding, which is designed to bind to
shared libraries. Unfortunately NaCl does not presently ship a shared library,
so RbNaCl cannot take advantage of it via FFI. RbNaCl will support usage with
the upstream NaCl once it is able to compile a shared library.

For now, to use RbNaCl, you will need to install libsodium, a portable version
of NaCl based upon the reference C code. Please see the libsodium project
for information regarding installation:

https://github.com/jedisct1/libsodium

Once you have libsodium installed, add this line to your application's Gemfile:

    gem 'rbnacl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbnacl

## Usage

### Authenticated secret-key encryption: Crypto::SecretBox

Think of SecretBox like a safe: you can put information inside of
it, and anyone with the combination can open it.  Also, like any
high security safe, any attempts to tamper with the safe or its
contents will be detected.

``` ruby
# generate a secret key (or perhaps use scrypt or PBKDF2)
key = Crypto::Random.random_bytes(Crypto::SecretBox::KEYBYTES)

# initialize the box
crypto_secret_box = Crypto::SecretBox.new(key)

# encrypt a message using the box.
# First, make a nonce.  One simple strategy is to use 24 random bytes.
# The nonce isn't secret, and can be sent with the ciphertext.
nonce = Crypto::Random.random_bytes(24)
message = "..."
ciphertext = crypto_secret_box.box(nonce, message)
#=> "..." # string of random looking bytes, 16 bytes longer than message

# decrypt a message
# NB: Same nonce used here.
decrypted_message = crypto_secret_box.open(nonce, ciphertext)
#=> "..."

# But if the ciphertext has been tampered with:
crypto_secret_box.open(nonce, corrupted_ciphertext)
#=> Crypto::CryptoError exception is raised.
# Chosen ciphertext attacks are prevented.
```


#### Algorithm details:
* **Encryption**: XSalsa20 stream cipher
* **Authentication**: Poly1305 one-time MAC

---

### Authenticated public-key encryption: Crypto::Box

Box works similarly to GPG: anyone can publish a public key, and
if you have someone's public key, you can put messages into the
box, but once closed, only the holder of the private key can open it.
However, unlike GPG, the box is defined by two pairs of keys (yours and
theirs) so they need your public key to open the box, too. By checking
both sets of keys, you're assured the box came from who you were expecting
and that it has not been tampered with. This bidirectional guarantee
around identity is known as [mutual authentication][mutualauth].

[mutualauth]: http://en.wikipedia.org/wiki/Mutual_authentication

TODO: Write Box instructions here

#### Algorithm details:
* **Encryption**: XSalsa20 stream cipher
* **Authentication**: Poly1305 one-time MAC
* **Public Keys**: Curve25519 elliptic curves

---

### Digital signatures: Crypto::SigningKey/Crypto::VerifyKey

In the real world, signatures help uniquely identify people because
everyone's signature is unique. Digital signatures work similarly in
that they are unique to holders of a private key, but unlike real
world signatures, digital signatures are unforgable.

Digital signatures allow you to publish a public key, then you can
use your private signing key to sign messages. Others who have your
public key can then use it to validate that your messages are actually
authentic.

#### Signer's perspective (Crypto::SigningKey):

```ruby
# Generate a new random signing key
signing_key = Crypto::SigningKey.generate

# Sign a message with the signing key
# Signature will be returned in hex format
signature = signing_key.sign(message, :hex)

# Obtain the verify key for a given signing key
verify_key = signing_key.verify_key

# Serialize the verify key to send it to a third party
# Verify key will be returned in hex format
verify_key.to_s(:hex)
```

#### Verifier's perspective (Crypto::VerifyKey):

```ruby
# Create a VerifyKey object from a hex serialized public key
verify_key = Crypto::VerifyKey.new(verify_key_hex, :hex)

# Check the validity of a message's signature
# Will raise Crypto::BadSignatureError if the signature check fails
verify_key.verify!(message, signature, :hex)
```

#### Algorithm details:
* **Signatures**: Ed25519 signature system
* **Public Keys**: Curve25519 elliptic curves

#### Security features:

* **Small keys**: Ed25519 keys are only 256-bits (32 bytes), making them
  small enough to easily copy around. Ed25519 also allows the public key
  to be derived from the private key, meaning that it doesn't need to be
  included in a serialized private key in cases you want both.
* **Small signatures**: Ed25519 signatures are only 512-bits (64 bytes),
  one of the smallest signature sizes available.
* **Deterministic**: Unlike (EC)DSA, Ed25519 does not rely on an entropy
  source when signing messages, but instead computes signature nonces from
  a combination of a hash of the signing key's "seed" and the message to
  be signed. This avoids using an entropy source for nonces, which can be
  a potential attack vector if the entropy source is not generating good
  random numbers. Even a single reused nonce can lead to a complete disclosure
  of the private key in these schemes, which Ed25519 avoids entirely by being
  deterministic instead of tied to an entropy source.
* **Collision Resistant**: Hash-function collisions do not break this
  system. This adds a layer of defense against the possibility of weakness
  in the selected hash function.

---

### Scalars

Scalars provide direct access to the Curve25519 function

TODO: Write Scalar instructions here

---

### Authenticators

TODO: Write Authenticator instructions here

---

### Hash functions

Cryptographic hash functions compute a fixed length string, the message digest.
Even a small change in the input data should produce a large change in the
digest, and it is 'very difficult' to create two messages with the same digest.

A cryptographic hash can be used for checking the integrity of data, but there
is no secret involved in the hashing, so anyone can create the hash of a given
message.

``` ruby
# compute the SHA-256 digest of the message.
Crypto::Hash.sha256(message)
#=> "..." # a string of bytes.

# compute the SHA-512 digest of the message and hex-encode it.
Crypto::Hash.sha512(message, :hex)
#=> "ab67..." # a string of hexidecimal bytes.
```

#### Algorithm Details

* **SHA-256** and **SHA-512**

---

### Utilities

There are some helpful functions for performing common tasks in cryptography.  These include random data generation (for example, for key material) using the operating system random source and constant-time comparisons of strings, to avoid exposing information through timing attacks.

``` ruby
# random strings
Crypto::Random.random_bytes(32)
#=> 32 bytes of randomness, from the OS

# constant time comparisons.
Crypto::Util.verify32(string_one, string_two)
#=> true/false.  See also verify16 
```

## Security Notes

NaCl itself has been expertly crafted to avoid a whole range of
side-channel attacks, however the RbNaCl code itself has not been
written with the same degree of expertise. While the code is
straightforward it should be considered experimental until audited
by professional cryptographers.

That said, it's probably still a million times better than OpenSSL...

## Contributing

* Fork this repository on github
* Make your changes and send me a pull request
* If I like them I'll merge them
* If I've accepted a patch, feel free to ask for commit access

## License

Copyright (c) 2013 Tony Arcieri, Jonathan Stott.
Distributed under the MIT License. See LICENSE.txt for further details.
