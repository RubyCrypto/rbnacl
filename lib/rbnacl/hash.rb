#!/usr/bin/env ruby
module Crypto
  module Hash
    def self.sha256(data)
      hash = "\0" * NaCl::SHA256_BYTES
      ret = NaCl.crypto_hash_sha256_ref(hash, data, data.bytesize)
      raise CryptoError, "Hashing failed!" unless ret == 0
      hash
    end
  end
end
