RbNaCl
======
[![Build Status](https://travis-ci.org/cryptosphere/rbnacl.png?branch=master)](https://travis-ci.org/cryptosphere/rbnacl)

A Ruby binding to the [Networking and Cryptography][nacl] library by Daniel
J. Bernstein. RbNaCl is also the empirical formula for Rubidium Sodium
Chloride. This is **NOT** Google Native Client. This is a crypto library.

[nacl]: http://nacl.cr.yp.to/

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
in the form of expertly-assembled high level cryptographic APIs that ensure
not only the confidentiality of your data, but also detect tampering.
The result is high-level, easy-to-use APIs which are designed to be
hard-to-attack by default in ways libraries like OpenSSL are not.

This approach makes NaCl a lot closer to a system like GPG than it is
to the cryptographic primitive APIs in a library like OpenSSL. However,
NaCl also uses state-of-the-art encryption, including Curve25519 elliptic
curves and the XSalsa20 stream cipher. This means with NaCl you not only get
a system which is designed to be secure-by-default, you also get one which
is extremely fast with comparatively small cryptographic keys.

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
it, and anyone with the combination can open it.

TODO: Write SecretBox usage instructions here

#### Algorithm details:
* **Encryption**: XSalsa20 stream cipher
* **Authentication**: Poly1305 one-time MAC

### Authenticated public-key encryption: Crypto::Box

Box works similarly to GPG: anyone can publish a public key, and
if you have someone's public key, you can put messages into the
box, but once closed, only the holder of the private key can open it.

TODO: Write Box instructions here

#### Algorithm details:
* **Encryption**: XSalsa20 stream cipher
* **Authentication**: Poly1305 one-time MAC
* **Public Keys**: Curve25519 elliptic curves

### Digital signatures: Crypto::SigningKey/Crypto::VerifyKey

In the real world, signatures help uniquely identify people because
everyone's signature is unique. Digital signatures work similarly in
that they are unique to holders of a private key, but unlike real
world signatures, digital signatures are unforgable.

Digital signatures allow you to publish a public key, then you can
use your private signing key to sign messages. Others who have your
public key can then use it to validate that your messages are actually
authentic.

TODO: Write Ed25519 instructions here

#### Algorithm details:
* **Signatures**: Ed25519 signature system
* **Public Keys**: Curve25519 elliptic curves

### Scalars

Scalars provide direct access to the Curve25519 function

TODO: Write Scalar instructions here

### Authenticators

TODO: Write Authenticator instructions here

### Hashes

TODO: Write hash instructions here

### Utilities

TODO: Write random/verify32/verify64/etc instructions here

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

Copyright (c) 2013 Tony Arcieri, Jonathan Stott
Distributed under the MIT License. See
LICENSE.txt for further details.
