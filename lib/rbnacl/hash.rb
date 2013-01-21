#!/usr/bin/env ruby
module Crypto
  module Hash
    def self.sha256(data)
      hash = Util.zeros(NaCl::SHA256BYTES)
      ret = NaCl.crypto_hash_sha256_ref(hash, data, data.bytesize)
      raise CryptoError, "Hashing failed!" unless ret == 0
      hash
    end
  end
end
