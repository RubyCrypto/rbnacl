# encoding: binary
module RbNaCl
  # Reference library of test vectors used to verify the software is correct
  TestVectors = {
    #
    # Curve25519 test vectors
    # Taken from the NaCl distribution
    #
    :alice_private  => "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a",
    :alice_public   => "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a",
    :bob_private    => "5dab087e624a8a4b79e17f8b83800ee66f3bb1292618b6fd1c2f8b27ff88e0eb",
    :bob_public     => "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f",
    :alice_mult_bob => "4a5d9d5ba4ce2de1728e3bf480350f25e07e21c947d19e3376f09b3c1e161742",

    #
    # Box test vectors
    # Taken from the NaCl distribution
    #
    :secret_key     => "1b27556473e985d462cd51197a9a46c76009549eac6474f206c4ee0844f68389",
    :box_nonce      => "69696ee955b62b73cd62bda875fc73d68219e0036b7a0b37",
    :box_message    => "be075fc53c81f2d5cf141316ebeb0c7b5228c52a4c62cbd44b66849b64244ffc" +
                       "e5ecbaaf33bd751a1ac728d45e6c61296cdc3c01233561f41db66cce314adb31" +
                       "0e3be8250c46f06dceea3a7fa1348057e2f6556ad6b1318a024a838f21af1fde" +
                       "048977eb48f59ffd4924ca1c60902e52f0a089bc76897040e082f93776384864" +
                       "5e0705",

    :box_ciphertext => "f3ffc7703f9400e52a7dfb4b3d3305d98e993b9f48681273c29650ba32fc76ce" +
                       "48332ea7164d96a4476fb8c531a1186ac0dfc17c98dce87b4da7f011ec48c972" +
                       "71d2c20f9b928fe2270d6fb863d51738b48eeee314a7cc8ab932164548e526ae" +
                       "90224368517acfeabd6bb3732bc0e9da99832b61ca01b6de56244a9e88d5f9b3" +
                       "7973f622a43d14a6599b1f654cb45a74e355a5",

    #
    # Ed25519 test vectors
    # Taken from the Python test vectors: http://ed25519.cr.yp.to/python/sign.input
    #
    :sign_private   => "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd",
    :sign_public    => "77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb",
    :sign_message   => "916c7d1d268fc0e77c1bef238432573c39be577bbea0998936add2b50a653171" +
                       "ce18a542b0b7f96c1691a3be6031522894a8634183eda38798a0c5d5d79fbd01" +
                       "dd04a8646d71873b77b221998a81922d8105f892316369d5224c9983372d2313" +
                       "c6b1f4556ea26ba49d46e8b561e0fc76633ac9766e68e21fba7edca93c4c7460" +
                       "376d7f3ac22ff372c18f613f2ae2e856af40",
    :sign_signature => "6bd710a368c1249923fc7a1610747403040f0cc30815a00f9ff548a896bbda0b" +
                       "4eb2ca19ebcf917f0f34200a9edbad3901b64ab09cc5ef7b9bcc3c40c0ff7509",

    #
    # SHA256 test vectors
    # Taken from the NSRL test vectors: http://www.nsrl.nist.gov/testdata/
    :sha256_message => "6162636462636465636465666465666765666768666768696768696a68696a6b" +
                       "696a6b6c6a6b6c6d6b6c6d6e6c6d6e6f6d6e6f706e6f7071",
    :sha256_digest  => "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
    :sha256_empty   => "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",

    #
    # SHA512 test vectors
    # self-created (FIXME: find standard test vectors)
    :sha512_message => "54686520717569636b2062726f776e20666f78206a756d7073206f7665722074" + 
                       "6865206c617a7920646f672e",
    :sha512_digest  => "91ea1245f20d46ae9a037a989f54f1f790f0a47607eeb8a14d12890cea77a1bb" +
                       "c6c7ed9cf205e67b7f2b8fd4c7dfd3a7a8617e45f3c463d481c7e586c39ac1ed",
    :sha512_empty   => "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce" +
                       "47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",

    # Blake2b test vectors
    # self-created? (TODO: double check, fix)
    :blake2b_message => "54686520717569636b2062726f776e20666f78206a756d7073206f7665722074" + 
                        "6865206c617a7920646f67",
    :blake2b_digest  => "a8add4bdddfd93e4877d2746e62817b116364a1fa7bc148d95090bc7333b3673" +
                        "f82401cf7aa2e4cb1ecd90296e3f14cb5413f8ed77be73045b13914cdcd6a918",
    :blake2b_empty   => "786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419" +
                        "d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce",

    # from the Blake2 paper(?) (TODO: double check)
    :blake2b_keyed_message => "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f" +
                              "202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f" +
                              "404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f" +
                              "606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f" +
                              "808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9f" +
                              "a0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebf" +
                              "c0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedf" +
                              "e0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfe",
    :blake2b_key           => "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f" +
                              "202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f",
    :blake2b_keyed_digest  => "142709d62e28fcccd0af97fad0f8465b971e82201dc51070faa0372aa43e9248" +
                              "4be1c1e73ba10906d5d1853db6a4106e0a7bf9800d373d6dee2d46d62ef2a461",

    # Auth test vectors
    # Taken from NaCl distribution
    #
    :auth_key           => "eea6a7251c1e72916d11c2cb214d3c252539121d8e234e652d651fa4c8cff880",
    :auth_message       => "8e993b9f48681273c29650ba32fc76ce48332ea7164d96a4476fb8c531a1186a" +
                           "c0dfc17c98dce87b4da7f011ec48c97271d2c20f9b928fe2270d6fb863d51738" +
                           "b48eeee314a7cc8ab932164548e526ae90224368517acfeabd6bb3732bc0e9da" +
                           "99832b61ca01b6de56244a9e88d5f9b37973f622a43d14a6599b1f654cb45a74" +
                           "e355a5",
    :auth_onetime       => "f3ffc7703f9400e52a7dfb4b3d3305d9",
    # self-created (FIXME: find standard test vectors)
    :auth_hmacsha256    => "7f7b9b707e8790ca8620ff94df5e6533ddc8e994060ce310c9d7de04d44aabc3",
    :auth_hmacsha512256 => "b2a31b8d4e01afcab2ee545b5caf4e3d212a99d7b3a116a97cec8e83c32e107d"
  }
end
