# encoding: binary
# frozen_string_literal: true

RSpec.describe RbNaCl::AEAD::ChaCha20Poly1305Legacy do
  include_examples "aead" do
    let(:key)        { vector :aead_chacha20poly1305_orig_key }
    let(:message)    { vector :aead_chacha20poly1305_orig_message }
    let(:nonce)      { vector :aead_chacha20poly1305_orig_nonce }
    let(:ad)         { vector :aead_chacha20poly1305_orig_ad }
    let(:ciphertext) { vector :aead_chacha20poly1305_orig_ciphertext }
  end
end
