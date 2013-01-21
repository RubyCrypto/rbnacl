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

You will need to install NaCl for your platform first. On OS X, you can do:

    brew install nacl

Add this line to your application's Gemfile:

    gem 'rbnacl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbnacl

## Usage

TODO: Write usage instructions here

## Contributing

* Fork this repository on github
* Make your changes and send me a pull request
* If I like them I'll merge them
* If I've accepted a patch, feel free to ask for commit access

## License

Copyright (c) 2012 Tony Arcieri. Copyright (c) 2013 Jonathan Stott
Distributed under the MIT License. See
LICENSE.txt for further details.
