3.4.0 (2015-05-07)
------------------
* [#135](https://github.com/cryptosphere/rbnacl/pull/135)
  Expose RbNaCl::Signatures::Ed25519#keypair_bytes.
  (@grempe)

* [#137](https://github.com/cryptosphere/rbnacl/pull/137)
  Expose HMAC-SHA512 (with 64-byte keys)
  (@mwpastore)

3.3.0 (2015-12-29)
------------------
* [#105](https://github.com/cryptosphere/rbnacl/pull/105)
  Add salt/personalisation strings for Blake2b.
  ([@namelessjon])

* [#128](https://github.com/cryptosphere/rbnacl/pull/128)
  Remove use of Thread.exclusive when initializing library.
  ([@tarcieri])

3.2.0 (2015-05-31)
------------------
* Fix method signature for blake2b
* RuboCop-friendly codebase

3.1.2 (2014-08-30)
------------------
* Fix scrypt support with libsodium 0.7.0 (scryptsalsa208sha256)

3.1.1 (2014-06-14)
------------------
* Fix undefined variable warning
* RSpec 3 fixups
* RuboCop

3.1.0 (2014-05-22)
------------------
* The scrypt password hashing function: RbNaCl::PasswordHash.scrypt

3.0.1 (2014-05-12)
------------------
* Load gem from RBNACL_LIBSODIUM_GEM_LIB_PATH if set. Used by rbnacl-libsodium
  gem to use libsodium compiled from a gem.

3.0.0 (2014-04-22)
------------------
* Rename RandomNonceBox to SimpleBox (backwards compatibility preserved)
* Reverse documented order of SimpleBox/RandomNonceBox initialize parameters.
  Technically backwards compatible, but confusing.
* Ensure all strings are ASCII-8BIT/BINARY encoding prior to use

2.0.0 (2013-11-07)
------------------
* Add encrypt/decrypt aliases for Crypto::RandomNonceBox
* Rename Crypto module to RbNaCl module
* RbNaCl::VerifyKey#verify operand order was reversed. New operand order is
  signature, message instead of message, signature
* RbNaCL::SecretBox#open, RbNaCl::Box#open, Auth#verify and VerifyKey#verify 
  all now raise a (descendent of) CryptoError if the check fails.  This ensures
  failures are handled by the program.
* RbNaCl::SecretBox, Box, etc. are all now aliases for the real implementations,
  which are named after the primitives they provide
* Encoders have now gone.
* Add support for the Blake2b cryptographic hash algorithm.
* Add checks that we have a sufficiently recent version of libsodium (0.4.3+)
* Dropped ruby-1.8 support
* Call the `sodium_init()` function, to select the best algorithms.
* Fix some typos in the documentation
* Changes in the low level binding for libsodium and removal of the NaCl module
* Add a mutex around calls to randombytes in libsodium

1.1.0 (2013-04-19)
------------------

* Provide API for querying primitives and details about them, such as key
  lengths, nonce lengths, etc.
* Fixed bug on passing null bytes to sha256, sha512 functions.

1.0.0 (2013-03-08)
------------------
* Initial release

[@namelessjon]: https://github.com/namelessjon
[@tarcieri]: https://github.com/tarcieri
