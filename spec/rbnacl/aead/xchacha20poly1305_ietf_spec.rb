# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::AEAD::XChaCha20Poly1305IETF do
  if RbNaCl::Sodium::Version.supported_version?("1.0.12")
    include_examples "aead" do
      let(:key)        { vector :aead_xchacha20poly1305_ietf_key }
      let(:message)    { vector :aead_xchacha20poly1305_ietf_message }
      let(:nonce)      { vector :aead_xchacha20poly1305_ietf_nonce }
      let(:ad)         { vector :aead_xchacha20poly1305_ietf_ad }
      let(:ciphertext) { vector :aead_xchacha20poly1305_ietf_ciphertext }
    end
  end
end
