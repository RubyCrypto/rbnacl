# encoding: binary
require "spec_helper"

RSpec.describe RbNaCl::AEAD::Chacha20Poly1305IETF do
  if RbNaCl::Sodium::Version.supported_version?("1.0.9")
    include_examples "aead" do
      let(:key) {vector :aead_chacha20poly1305_ietf_key}
      let(:message) {vector :aead_chacha20poly1305_ietf_message}
      let(:nonce) {vector :aead_chacha20poly1305_ietf_nonce}
      let(:ad) {vector :aead_chacha20poly1305_ietf_ad}
      let(:ciphertext) {vector :aead_chacha20poly1305_ietf_ciphertext}

      let(:aead) { RbNaCl::AEAD::Chacha20Poly1305IETF.new(key) }
    end
  end
end
