# encoding: binary
module RbNaCl
  module Hash
    # Provides a binding for the SHA256 function in libsodium
    module SHA256
      extend Sodium
      sodium_type      :hash
      sodium_primitive :sha256
      sodium_constant  :BYTES
      sodium_function  :hash_sha256,
        :crypto_hash_sha256,
        [:pointer, :pointer, :ulong_long]
    end
  end
end
