module Crypto
  module TestVectors
    def self.[](name)
      Crypto::Encoder[:hex].decode(const_get(name.to_s))
    end

    ALICE_SECRET_KEY = "77076d0a7318a57d3c16c17251b26645df4c2f87ebc0992ab177fba51db92c2a"
    ALICE_PUBLIC_KEY = "8520f0098930a754748b7ddcb43ef75a0dbf3a0d26381af4eba4a98eaa9b4e6a"

    BOB_PUBLIC_KEY = "de9edb7d7b7dc1b4d35b61c2ece435373f8343c85b78674dadfc7e146f882b4f"
  end
end