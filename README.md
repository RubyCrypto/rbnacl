![RbNaCl](https://raw.github.com/cryptosphere/rbnacl/master/images/logo.png)
======
[![Gem Version](https://badge.fury.io/rb/rbnacl.svg)](http://badge.fury.io/rb/rbnacl)
[![Build Status](https://travis-ci.org/cryptosphere/rbnacl.svg?branch=master)](https://travis-ci.org/cryptosphere/rbnacl)
[![Code Climate](https://codeclimate.com/github/cryptosphere/rbnacl.svg)](https://codeclimate.com/github/cryptosphere/rbnacl)
[![Coverage Status](https://coveralls.io/repos/cryptosphere/rbnacl/badge.svg?branch=master)](https://coveralls.io/r/cryptosphere/rbnacl)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/cryptosphere/rbnacl/blob/master/LICENSE.txt)

A Ruby binding to the state-of-the-art [Networking and Cryptography][nacl]
library by [Daniel J. Bernstein][djb]. This is **NOT** Google Native Client.
This is a crypto library.

On a completely unrelated topic, RbNaCl is also the empirical formula for
Rubidium Sodium Chloride.

Need help with RbNaCl? Join the [RbNaCl Google Group][group].
We're also on IRC at #cryptosphere on irc.freenode.net

[nacl]:  http://nacl.cr.yp.to/
[djb]:   http://cr.yp.to/djb.html
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

For more information on NaCl's goals, see Dan Bernstein's presentation
[Blaming the Cryptographic User](http://cr.yp.to/talks/2012.08.08/slides.pdf)

### Is it any good?

[Yes.](http://news.ycombinator.com/item?id=3067434)

## Supported platforms

You can use RbNaCl anywhere you can get libsodium installed (see below).
RbNaCl is continuously integration tested on the following Ruby VMs:

* MRI 2.0, 2.1, 2.2, 2.3
* JRuby 1.7, 9000

## Installation

Note: [Windows installation instructions are available](https://github.com/cryptosphere/rbnacl/wiki/Windows-Installation).

### libsodium

**NOTE: Want to avoid the hassle of installing libsodium? Use the
[rbnacl-libsodium](https://github.com/cryptosphere/rbnacl-libsodium) gem**

To use RbNaCl, you will need to install libsodium:

https://github.com/jedisct1/libsodium

At least version `1.0.0` is recommended.

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

[RDoc documentation][rdoc] is also available.

[wiki]: https://github.com/cryptosphere/rbnacl/wiki
[simplebox]: https://github.com/cryptosphere/rbnacl/wiki/SimpleBox
[secretkey]: https://github.com/cryptosphere/rbnacl/wiki/Secret-Key-Encryption
[publickey]: https://github.com/cryptosphere/rbnacl/wiki/Public-Key-Encryption
[signatures]: https://github.com/cryptosphere/rbnacl/wiki/Digital-Signatures
[macs]: https://github.com/cryptosphere/rbnacl/wiki/Authenticators
[hashes]: https://github.com/cryptosphere/rbnacl/wiki/Hash-Functions
[rdoc]: http://rubydoc.info/github/cryptosphere/rbnacl/master/frames

## Reporting Security Problems

If you have discovered a bug in RbNaCl of a sensitive nature, i.e.
one which can compromise the security of RbNaCl users, you can
report it securely by sending a GPG encrypted message. Please use
the following key:

https://raw.github.com/cryptosphere/rbnacl/master/bascule.asc

The key fingerprint is (or should be):

`9148 85A2 6242 1628 B6AA AB45 4CB9 B3D0 BACC 8B71`

## Learn More

While NaCl has designed to be easier-than-usual to use for a crypto
library, cryptography is an incredibly difficult subject and it's
always helpful to know as much as you can about it before applying
it to a particular use case. That said, the creator of NaCl, Dan
Bernstein, has published a number of papers about NaCl. If you are
interested in learning more about how NaCl works, it's recommended
that you read them:

* [Cryptography in NaCl](http://cr.yp.to/highspeed/naclcrypto-20090310.pdf)
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

Copyright (c) 2012-2016 Jonathan Stott, Tony Arcieri. Distributed under the MIT License.
See LICENSE.txt for further details.
