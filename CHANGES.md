2.0.0.pre
---------
* ZOMG LOTS OF STUFF! We should make we get it all added to this file!
* Add encrypt/decrypt aliases for Crypto::RandomNonceBox
* Rename Crypto module to RbNaCl module
* RbNaCl::VerifyKey#verify operand order was reversed. New operand order is
  signature, message instead of message, signature

1.1.0 (2013-04-19)
------------------

* Provide API for querying primitives and details about them, such as key
  lengths, nonce lengths, etc.
* Fixed bug on passing null bytes to sha256, sha512 functions.

1.0.0 (2013-03-08)
------------------
* Initial release
