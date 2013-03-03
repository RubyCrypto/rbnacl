# Self-test failed!
class Crypto::SelfTestFailure < Crypto::CryptoError; end

#
# Digital Signature Test
#

signing_key = Crypto::SigningKey.new(Crypto::TestVectors[:sign_private], :hex)
verify_key  = signing_key.verify_key

unless verify_key.to_s(:hex) == Crypto::TestVectors[:sign_public]
  raise Crypto::SelfTestFailure, "failed to generate verify key correctly"
end

message   = Crypto::Encoder[:hex].decode Crypto::TestVectors[:sign_message]
signature = signing_key.sign(message, :hex)

unless signature == Crypto::TestVectors[:sign_signature]
  raise Crypto::SelfTestFailure, "failed to generate correct signature"
end

unless verify_key.verify(message, signature, :hex)
  raise Crypto::SelfTestFailure, "failed to verify a valid signature"
end

bad_signature = signature[0,127] + '0'

unless verify_key.verify(message, bad_signature, :hex) == false
  raise Crypto::SelfTestFailure, "failed to detect an invalid signature"
end