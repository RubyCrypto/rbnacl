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
