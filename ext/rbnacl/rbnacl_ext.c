/*
 * Copyright (c) 2012 Tony Arcieri. Distributed under the MIT License. See
 * LICENSE.txt for further details.
 */

#include <crypto_hash_sha256.h>
#include <crypto_box.h>

#include "ruby.h"

static VALUE mCrypto = Qnil;
static VALUE mCrypto_Hash = Qnil;
static VALUE cCrypto_CryptoError = Qnil;
static VALUE cCrypto_KeyPair = Qnil;
static VALUE Crypto_Hash_sha256(VALUE self, VALUE size);
static VALUE Crypto_KeyPair_generate(VALUE self);
static VALUE Crypto_KeyPair_valid_pk(VALUE self, VALUE pk);
static VALUE Crypto_KeyPair_valid_sk(VALUE self, VALUE sk);
static ID id_new   = 0;

void Init_rbnacl_ext()
{
  id_new  = rb_intern("new");

  mCrypto = rb_define_module("Crypto");
  mCrypto_Hash = rb_define_module_under(mCrypto, "Hash");

  rb_define_singleton_method(mCrypto_Hash, "sha256", Crypto_Hash_sha256, 1);

  cCrypto_CryptoError = rb_define_class_under(mCrypto, "CryptoError", rb_eStandardError);

  cCrypto_KeyPair = rb_define_class_under(mCrypto, "KeyPair", rb_cObject);
  rb_define_singleton_method(cCrypto_KeyPair, "generate", Crypto_KeyPair_generate, 0);
  rb_define_singleton_method(cCrypto_KeyPair, "valid_pk?", Crypto_KeyPair_valid_sk, 1);
  rb_define_singleton_method(cCrypto_KeyPair, "valid_sk?", Crypto_KeyPair_valid_pk, 1);
}

static VALUE Crypto_Hash_sha256(VALUE self, VALUE string)
{
  VALUE hash = rb_str_new(0, crypto_hash_sha256_BYTES);

  crypto_hash_sha256(RSTRING_PTR(hash), RSTRING_PTR(string), RSTRING_LEN(string));
  return hash;
}

static VALUE Crypto_KeyPair_generate(VALUE self)
{
    VALUE pk = rb_str_new(0, crypto_box_PUBLICKEYBYTES);
    VALUE sk = rb_str_new(0, crypto_box_SECRETKEYBYTES);

    int ret = crypto_box_keypair(RSTRING_PTR(pk), RSTRING_PTR(sk));
    if (0 != ret) {
        rb_raise (cCrypto_CryptoError, "Failed to generate key pair");
    }
    VALUE new = Qnil;
    new = rb_funcall(cCrypto_KeyPair, id_new, 2, pk, sk);
    return new;
}

static VALUE Crypto_KeyPair_valid_sk(VALUE self, VALUE sk)
{
    VALUE str = rb_funcall(sk, id_to_s, 0);
    if (crypto_box_SECRETKEYBYTES != RSTRING_LEN(str)) {
        return Qfalse;
    } else {
        return Qtrue;
    }
}

static VALUE Crypto_KeyPair_valid_pk(VALUE self, VALUE pk)
{
    VALUE str = rb_funcall(pk, id_to_s, 0);
    if (crypto_box_PUBLICKEYBYTES != RSTRING_LEN(str)) {
        return Qfalse;
    } else {
        return Qtrue;
    }
}
