module Crypto
  TestVectors = {

    :alice_private  => "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a",
    :alice_public   => "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a",

    :bob_public     => "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f",

    :alice_mult_bob => "4a5d9d5ba4ce2de1728e3bf480350f25e07e21c947d19e3376f09b3c1e161742",

    :auth_key           => "eea6a7251c1e72916d11c2cb214d3c252539121d8e234e652d651fa4c8cff880",
    :auth_message       => "8e993b9f48681273c29650ba32fc76ce48332ea7164d96a4476fb8c531a1186a" +
                           "c0dfc17c98dce87b4da7f011ec48c97271d2c20f9b928fe2270d6fb863d51738" +
                           "b48eeee314a7cc8ab932164548e526ae90224368517acfeabd6bb3732bc0e9da" +
                           "99832b61ca01b6de56244a9e88d5f9b37973f622a43d14a6599b1f654cb45a74" +
                           "e355a5",
    :auth_onetime       => "f3ffc7703f9400e52a7dfb4b3d3305d9",
    :auth_hmacsha256    => "7f7b9b707e8790ca8620ff94df5e6533ddc8e994060ce310c9d7de04d44aabc3",
    :auth_hmacsha512256 => "b2a31b8d4e01afcab2ee545b5caf4e3d212a99d7b3a116a97cec8e83c32e107d",
  }
end
