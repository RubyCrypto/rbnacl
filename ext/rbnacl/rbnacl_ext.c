/*
 * Copyright (c) 2012 Tony Arcieri. Distributed under the MIT License. See
 * LICENSE.txt for further details.
 */

#include <crypto_hash_sha256.h>

#include "ruby.h"

static VALUE mCrypto = Qnil;
static VALUE mCrypto_Hash = Qnil;
static VALUE Crypto_Hash_sha256(VALUE self, VALUE size);

void Init_rbnacl_ext()
{
  mCrypto = rb_define_module("Crypto");
  mCrypto_Hash = rb_define_module_under(mCrypto, "Hash");

  rb_define_singleton_method(mCrypto_Hash, "sha256", Crypto_Hash_sha256, 1);
}

static VALUE Crypto_Hash_sha256(VALUE self, VALUE string)
{
  VALUE hash = rb_str_new(0, crypto_hash_sha256_BYTES);

  crypto_hash_sha256(RSTRING_PTR(hash), RSTRING_PTR(string), RSTRING_LEN(string));
  return hash;
}