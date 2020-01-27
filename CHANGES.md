## [7.1.1] (2020-01-27)

- Test on Ruby 2.7 ([#208])
- Add project metadata to the gemspec ([#207])
- Resolve FFI deprecation warning ([#206])

## [7.1.0] (2019-09-07)

- Attached signature API ([#197], [#202])
- Fix the `generichash` state definition ([#200])

## [7.0.0] (2019-05-23)

- Drop support for Ruby 2.2 ([#194])

## [6.0.1] (2019-01-27)

- Add fallback `sodium_constants` for Argon2 ([#189])
- Support libsodium versions used by Heroku ([#186])
- Sealed boxes ([#184])

## [6.0.0] (2018-11-08)

- Deprecate rbnacl-libsodium ([#180])
- Add support for XChaCha20-Poly1305 ([#176])
- Fix buffer size type in `randombytes_buf` binding ([#174])
- Add support for argon2id digest ([#174])
- Support for non-32-byte HMAC-SHA256/512 keys ([#166])

## 5.0.0 (2017-06-13)

- Support the BLAKE2b Initialize-Update-Finalize API ([#159])

## 4.0.2 (2017-03-12)

- Raise error on degenerate keys. Fixes #152 ([#157])

## 4.0.1 (2016-12-04)

- Last minute changes to the ChaCha20Poly1305 API ([#148])

## 4.0.0 (2016-12-04)

- Add wrappers for ChaCha20Poly1305 AEAD ciphers ([#141])
- Added support for Argon2 password hash ([#142])
- Require Ruby 2.2.6+ ([#143])

## 3.4.0 (2015-05-07)

- Expose `RbNaCl::Signatures::Ed25519#keypair_bytes` ([#135])
- Expose HMAC-SHA512 with 64-byte keys ([#137]) 

## 3.3.0 (2015-12-29)

- Remove use of Thread.exclusive when initializing library ([#128])
- Add salt/personalisation strings for Blake2b ([#105])

## 3.2.0 (2015-05-31)

- Fix method signature for blake2b
- RuboCop-friendly codebase

## 3.1.2 (2014-08-30)

- Fix scrypt support with libsodium 0.7.0 (scryptsalsa208sha256)

## 3.1.1 (2014-06-14)

- Fix undefined variable warning
- RSpec 3 fixups
- RuboCop

## 3.1.0 (2014-05-22)

- The scrypt password hashing function: `RbNaCl::PasswordHash.scrypt`

## 3.0.1 (2014-05-12)

- Load gem from `RBNACL_LIBSODIUM_GEM_LIB_PATH` if set. Used by rbnacl-libsodium
  gem to use libsodium compiled from a gem.

## 3.0.0 (2014-04-22)

- Rename RandomNonceBox to SimpleBox (backwards compatibility preserved)
- Reverse documented order of SimpleBox/RandomNonceBox initialize parameters.
  Technically backwards compatible, but confusing.
- Ensure all strings are ASCII-8BIT/BINARY encoding prior to use

## 2.0.0 (2013-11-07)

- Rename Crypto module to RbNaCl module
- Add encrypt/decrypt aliases for `Crypto::RandomNonceBox`
- `RbNaCl::VerifyKey#verify` operand order was reversed. New operand order is
  signature, message instead of message, signature
- `RbNaCL::SecretBox#open`, `RbNaCl::Box#open`, `Auth#verify` and
  `VerifyKey#verify` all now raise a (descendent of) CryptoError if the check
  fails.  This ensures failures are handled by the program.
- `RbNaCl::SecretBox`, Box, etc. are all now aliases for the real
  implementations, which are named after the primitives they provide
- Removed encoder functionality.
- Add support for the Blake2b cryptographic hash algorithm.
- Add checks that we have a sufficiently recent version of libsodium (0.4.3+)
- Dropped ruby-1.8 support
- Call the `sodium_init()` function, to select the best algorithms.
- Fix some typos in the documentation
- Changes in the low level binding for libsodium and removal of the NaCl module
- Add a mutex around calls to randombytes in libsodium

## 1.1.0 (2013-04-19)

- Provide API for querying primitives and details about them, such as key
  lengths, nonce lengths, etc.
- Fixed bug on passing null bytes to sha256, sha512 functions.

## 1.0.0 (2013-03-08)

- Initial release

[7.1.1]: https://github.com/RubyCrypto/rbnacl/pull/210
[#208]: https://github.com/RubyCrypto/rbnacl/pull/208
[#207]: https://github.com/RubyCrypto/rbnacl/pull/207
[#206]: https://github.com/RubyCrypto/rbnacl/pull/206
[7.1.0]: https://github.com/RubyCrypto/rbnacl/pull/203
[#202]: https://github.com/RubyCrypto/rbnacl/pull/202
[#200]: https://github.com/RubyCrypto/rbnacl/pull/200
[#197]: https://github.com/RubyCrypto/rbnacl/pull/197
[7.0.0]: https://github.com/RubyCrypto/rbnacl/pull/195
[#194]: https://github.com/RubyCrypto/rbnacl/pull/194
[6.0.1]: https://github.com/RubyCrypto/rbnacl/pull/191
[#189]: https://github.com/RubyCrypto/rbnacl/pull/189
[#186]: https://github.com/RubyCrypto/rbnacl/pull/186
[#184]: https://github.com/RubyCrypto/rbnacl/pull/184
[6.0.0]: https://github.com/RubyCrypto/rbnacl/pull/182
[#180]: https://github.com/RubyCrypto/rbnacl/pull/180
[#176]: https://github.com/RubyCrypto/rbnacl/pull/176
[#174]: https://github.com/RubyCrypto/rbnacl/pull/174
[#172]: https://github.com/RubyCrypto/rbnacl/pull/172
[#166]: https://github.com/RubyCrypto/rbnacl/pull/166
[#159]: https://github.com/RubyCrypto/rbnacl/pull/159
[#157]: https://github.com/RubyCrypto/rbnacl/pull/157
[#148]: https://github.com/RubyCrypto/rbnacl/pull/148
[#143]: https://github.com/RubyCrypto/rbnacl/pull/143
[#142]: https://github.com/RubyCrypto/rbnacl/pull/142
[#141]: https://github.com/RubyCrypto/rbnacl/pull/141
[#137]: https://github.com/RubyCrypto/rbnacl/pull/137
[#135]: https://github.com/RubyCrypto/rbnacl/pull/135
[#128]: https://github.com/RubyCrypto/rbnacl/pull/128
[#105]: https://github.com/RubyCrypto/rbnacl/pull/105
