![RbNaCl](https://raw.github.com/cryptosphere/rbnacl/master/images/logo.png)
======
[![Gem Version](https://badge.fury.io/rb/rbnacl.png)](http://badge.fury.io/rb/rbnacl)
[![Build Status](https://travis-ci.org/cryptosphere/rbnacl.png?branch=master)](https://travis-ci.org/cryptosphere/rbnacl)
[![Code Climate](https://codeclimate.com/github/cryptosphere/rbnacl.png)](https://codeclimate.com/github/cryptosphere/rbnacl)
[![Coverage Status](https://coveralls.io/repos/cryptosphere/rbnacl/badge.png?branch=master)](https://coveralls.io/r/cryptosphere/rbnacl)

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

* MRI 2.0
* MRI 1.9 (YARV)
* JRuby 1.7 (in both 1.8/1.9 mode)
* Rubinius HEAD (in both 1.8/1.9 mode)

In theory Windows should be supported, although there are not yet any
reports of successful Windows users.

## Installation

### libsodium

RbNaCl is implemented as a Ruby FFI binding, which is designed to bind to
shared libraries. Unfortunately NaCl does not presently ship a shared library,
so RbNaCl cannot take advantage of it via FFI. RbNaCl will support usage with
the upstream NaCl once it is able to compile a shared library.

For now, to use RbNaCl, you will need to install libsodium, a portable version
of NaCl based upon the reference C code. Please see the libsodium project
for information regarding installation:

https://github.com/jedisct1/libsodium

For OS X users, libsodium is available via homebrew and can be installed with:

    brew install libsodium

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
[secretkey]: https://github.com/cryptosphere/rbnacl/wiki/Secret-Key-Encryption
[publickey]: https://github.com/cryptosphere/rbnacl/wiki/Public-Key-Encryption
[signatures]: https://github.com/cryptosphere/rbnacl/wiki/Digital-Signatures
[macs]: https://github.com/cryptosphere/rbnacl/wiki/Authenticators
[hashes]: https://github.com/cryptosphere/rbnacl/wiki/Hash-Functions
[rdoc]: http://rubydoc.info/github/cryptosphere/rbnacl/master/frames

## Security Notes

NaCl itself has been expertly crafted to avoid a whole range of
side-channel attacks, however the RbNaCl code itself has not been
written with the same degree of expertise. While the code is
straightforward it should be considered experimental until audited
by professional cryptographers.

That said, it's probably still a million times better than OpenSSL...

## Using Signed Gems

The RbNaCl gem is signed by Tony Arcieri's certificate, which identifies
as `bascule@gmail.com`. You can obtain the official certificate with:

```
curl https://raw.github.com/cryptosphere/rbnacl/master/bascule.cert > /tmp/bascule.cert
gem cert -a /tmp/bascule.cert
```

You can verify the authenticity of bascule.cert by its SHA256 hash:

```
$ shasum -a 256 bascule.cert
6e8b7e53d347ca6c6d214efef2b923aadecdd7650565f0eb1d8d0419723ae20c  bascule.cert
```

If you get a different number than `6e8b7e53...`, this is not the cert you are
looking for!

If you'd like to install the gem in high security mode, run:

```
gem install rbnacl-1.0.0.gem -P HighSecurity
```

## Reporting Security Problems

If you have discovered a bug in RbNaCl of a sensitive nature, i.e.
one which can compromise the security of RbNaCl users, you can
report it securely by sending a GPG encrypted message. Please use
the following key:

https://raw.github.com/cryptosphere/rbnacl/master/rbnacl.gpg

The key fingerprint is (or should be):

`190E 42D6 8327 A515 BFDF AAE0 B210 269D BB2D 8787`

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

### Does it have a lock with a checkmark?

Sure, here you go:

![Checkmarked Lock](http://i.imgur.com/dwA0Ffi.png)

### Is it full of NSA backdoors?

![No NIST](http://i.imgur.com/HSxeAmp.png)

The design of RbNaCl's primitives is completely free from NIST (and by
association, NSA) influence, with the following minor exceptions:

* The Poly1305 MAC, used for authenticating integrity of ciphertexts, uses AES
  as a replaceable component
* The Ed25519 digital signature algorithm uses SHA-512 for both key derivation
  and computing message digests
* APIs are provided to certain NIST hash functions, including SHA-256, SHA-512,
  and their associated HMAC counterparts

Otherwise, all of the algorithms in NaCl were designed by Dan Bernstein and his
collaborators.

The design choices in NaCl, particularly in regard to the Curve25519
Diffie-Hellman function, emphasize security (whereas [NIST curves emphasize
"performance" at the cost of security][nist-security-dangers]), and "magic
constants" in NaCl are picked by theorems designed to maximize security.
The same cannot be said of NIST curves, where the specific origins of certain
constants are not described by the standards and may be subject to malicious
influence by the NSA.

It is the opinion of this library's authors that Dan Bernstein is unlikely to be
subject to NSA influence (although we have no way of actually knowing this).

Dan Bernstein's designs have been well-scrutinized both as part of the [ESTREAM
Project](https://en.wikipedia.org/wiki/ESTREAM) and the cryptographic community
as a whole. And despite the emphasis on higher security, NaCl's primitives are
faster across-the-board than most implementations of the NIST standards.

[nist-security-dangers]: http://www.hyperelliptic.org/tanja/vortraege/20130531.pdf

## Contributing

* Fork this repository on Github
* Make your changes and send a pull request
* If your changes look good, we'll merge 'em

## License

Copyright (c) 2013 Jonathan Stott, Tony Arcieri.
Distributed under the MIT License. See LICENSE.txt for further details.
