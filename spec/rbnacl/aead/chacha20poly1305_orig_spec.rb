# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::AEAD::Chacha20Poly1305 do
  include_examples "aead" do
    let(:key) {vector :aead_chacha20poly1305_orig_key}
    let(:message) {vector :aead_chacha20poly1305_orig_message}
    let(:nonce) {vector :aead_chacha20poly1305_orig_nonce}
    let(:ad) {vector :aead_chacha20poly1305_orig_ad}
    let(:ciphertext) {vector :aead_chacha20poly1305_orig_ciphertext}

    let(:aead) { RbNaCl::AEAD::Chacha20Poly1305.new(key) }
  end
end
