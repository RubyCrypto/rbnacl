# encoding: binary
module RbNaCl
  module Hash
    # Provides the binding for the SHA512 hash function
    module SHA512
      extend Sodium
      sodium_type      :hash
      sodium_primitive :sha512
      sodium_constant  :BYTES
      sodium_function  :hash_sha512,
                       :crypto_hash_sha512,
                       [:pointer, :pointer, :ulong_long]
    end
  end
end
