![RbNaCl](https://raw.github.com/RubyCrypto/rbnacl/master/images/logo.png)
======
[![Gem Version](https://badge.fury.io/rb/rbnacl.svg)](http://badge.fury.io/rb/rbnacl)
[![Build Status](https://travis-ci.org/RubyCrypto/rbnacl.svg?branch=master)](https://travis-ci.org/RubyCrypto/rbnacl)
[![Code Climate](https://codeclimate.com/github/RubyCrypto/rbnacl.svg)](https://codeclimate.com/github/RubyCrypto/rbnacl)
[![Coverage Status](https://coveralls.io/repos/RubyCrypto/rbnacl/badge.svg?branch=master)](https://coveralls.io/r/RubyCrypto/rbnacl)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/RubyCrypto/rbnacl/blob/master/LICENSE.txt)

Ruby binding for [libsodium], a fork of the [Networking and Cryptography][NaCl]
library.

[libsodium]: https://libsodium.org
[NaCl]:  http://nacl.cr.yp.to/

## Why libsodium/NaCl?

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

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

## Supported platforms

You can use RbNaCl on platforms libsodium is supported (see below).

This library aims to support and is [tested against][travis] the following Ruby
versions:

* Ruby 2.5
* Ruby 2.6
* Ruby 2.7
* JRuby 9.2

If something doesn't work on one of these versions, it's a bug.

[travis]: http://travis-ci.org/RubyCrypto/rbnacl

## Installation

Note: [Windows installation instructions are available](https://github.com/RubyCrypto/rbnacl/wiki/Installing-libsodium#windows).

### libsodium

To use RbNaCl, you will need to install libsodium:

https://github.com/jedisct1/libsodium

At least version `1.0.0` is required.

For OS X users, libsodium is available via homebrew and can be installed with:

    brew install libsodium

For FreeBSD users, libsodium is available both via pkgng and ports.  To install
a binary package:

    pkg install libsodium

To install from ports on FreeBSD, use your favorite ports front end (e.g.
portmaster or portupgrade), or use make as follows:

    cd /usr/ports/security/libsodium; make install clean

### RbNaCl gem

Once you have libsodium installed, add this line to your application's Gemfile:

    gem 'rbnacl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rbnacl

Inside of your Ruby program do:

    require 'rbnacl'

...to pull it in as a dependency.

## Documentation

RbNaCl's documentation can be found [in the Wiki][wiki]. The following features
are supported:

* [SimpleBox]: easy-to-use public-key or secret-key encryption "on Rails"
* [Secret-key Encryption][secretkey]: authenticated symmetric encryption using a
  single key shared among parties
* [Public-key Encryption][publickey]: securely send messages to a given public
  key which can only be decrypted by a secret key
* [Digital Signatures][signatures]: sign messages with a private key which can
  be verified by a public one
* [Authenticators][macs]: create codes which can be used to check the
  authenticity of messages
* [Hash Functions][hashes]: compute a secure, fixed-length code from a message
  which does not reveal the contents of the message

Additional power-user features are available. Please see the Wiki for further
information.

[YARD API documentation][yard] is also available.

[wiki]: https://github.com/RubyCrypto/rbnacl/wiki
[simplebox]: https://github.com/RubyCrypto/rbnacl/wiki/SimpleBox
[secretkey]: https://github.com/RubyCrypto/rbnacl/wiki/Secret-Key-Encryption
[publickey]: https://github.com/RubyCrypto/rbnacl/wiki/Public-Key-Encryption
[signatures]: https://github.com/RubyCrypto/rbnacl/wiki/Digital-Signatures
[macs]: https://github.com/RubyCrypto/rbnacl/wiki/HMAC
[hashes]: https://github.com/RubyCrypto/rbnacl/wiki/Hash-Functions
[yard]: http://www.rubydoc.info/gems/rbnacl

## Learn More

While NaCl has designed to be easier-than-usual to use for a crypto
library, cryptography is an incredibly difficult subject and it's
always helpful to know as much as you can about it before applying
it to a particular use case. That said, the creator of NaCl, Dan
Bernstein, has published a number of papers about NaCl. If you are
interested in learning more about how NaCl works, it's recommended
that you read them:

* [Cryptography in NaCl](http://cr.yp.to/highspeed/naclcrypto-20090310.pdf)
* [Salsa20 Design](https://cr.yp.to/snuffle/design.pdf)
* [Curve25519: new Diffie-Hellman speed records](http://cr.yp.to/ecdh/curve25519-20060209.pdf)
* [Ed25519: High-speed high-security signatures](http://ed25519.cr.yp.to/ed25519-20110926.pdf)

For more information on libsodium, please check out the
[Introducing Sodium blog post](http://labs.umbrella.com/2013/03/06/announcing-sodium-a-new-cryptographic-library/)

Have a general interest in cryptography? Check out the free course
Coursera offers from Stanford University Professor Dan Boneh:

[http://crypto-class.org](http://crypto-class.org)

## Important Questions

### Is it "Military Grade™"?

Only if your military understands twisted Edwards curves

### Is it "Bank Grade™"?

No, that means 3DES, which this library doesn't support, sorry

### Does it have a lock with a checkmark?

Sure, here you go:

![Checkmarked Lock](http://i.imgur.com/dwA0Ffi.png)

## Contributing

* Fork this repository on Github
* Make your changes and send a pull request
* If your changes look good, we'll merge 'em

## License

Copyright (c) 2012-2018 Tony Arcieri, Jonathan Stott. Distributed under the MIT License.
See [LICENSE.txt] for further details.

[LICENSE.txt]: https://github.com/RubyCrypto/rbnacl/blob/master/LICENSE.txt
