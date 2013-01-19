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
static VALUE cCrypto_Boxer = Qnil;
static VALUE Crypto_Hash_sha256(VALUE self, VALUE size);
static VALUE Crypto_KeyPair_generate(VALUE self);
static VALUE Crypto_KeyPair_valid_pk(VALUE self, VALUE pk);
static VALUE Crypto_KeyPair_valid_sk(VALUE self, VALUE sk);
static VALUE Crypto_Boxer_beforenm(VALUE self);
static VALUE Crypto_Boxer_box(VALUE self, VALUE nonce, VALUE pt);
static VALUE Crypto_Boxer_unbox(VALUE self, VALUE nonce, VALUE ct);
static ID id_pk    = 0;
static ID id_sk    = 0;
static ID id_k     = 0;
static ID id_to_s  = 0;
static ID id_new   = 0;

void Init_rbnacl_ext()
{
  id_pk   = rb_intern("@pk");
  id_sk   = rb_intern("@sk");
  id_k    = rb_intern("@k");
  id_to_s = rb_intern("to_s");
  id_new  = rb_intern("new");

  mCrypto = rb_define_module("Crypto");
  mCrypto_Hash = rb_define_module_under(mCrypto, "Hash");

  rb_define_singleton_method(mCrypto_Hash, "sha256", Crypto_Hash_sha256, 1);

  cCrypto_CryptoError = rb_define_class_under(mCrypto, "CryptoError", rb_eStandardError);

  cCrypto_KeyPair = rb_define_class_under(mCrypto, "KeyPair", rb_cObject);
  rb_define_singleton_method(cCrypto_KeyPair, "generate", Crypto_KeyPair_generate, 0);
  rb_define_singleton_method(cCrypto_KeyPair, "valid_pk?", Crypto_KeyPair_valid_sk, 1);
  rb_define_singleton_method(cCrypto_KeyPair, "valid_sk?", Crypto_KeyPair_valid_pk, 1);

  cCrypto_Boxer = rb_define_class_under(mCrypto, "Boxer", rb_cObject);
  rb_define_const(cCrypto_Boxer, "NONCE_LEN", INT2FIX(crypto_box_NONCEBYTES));
  rb_define_private_method(cCrypto_Boxer, "beforenm", Crypto_Boxer_beforenm, 0);
  rb_define_method(cCrypto_Boxer, "box", Crypto_Boxer_box, 2);
  rb_define_method(cCrypto_Boxer, "unbox", Crypto_Boxer_unbox, 2);
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

static VALUE Crypto_Boxer_beforenm(VALUE self)
{
    VALUE k  = rb_ivar_get(self, id_k);
    if (NIL_P(k)) {
        VALUE pk = rb_ivar_get(self, id_pk);
        VALUE sk = rb_ivar_get(self, id_sk);
        k = rb_str_new(0, crypto_box_BEFORENMBYTES);
        int ret = crypto_box_beforenm(RSTRING_PTR(k), RSTRING_PTR(pk), RSTRING_PTR(sk));
        if (0 != ret) { // no idea how this could happen
            rb_raise (cCrypto_CryptoError, "Failed to derived shared key");
        }
        rb_ivar_set(self, id_k, k);
    }
    return k;
}

static VALUE Crypto_Boxer_box(VALUE self, VALUE nonce, VALUE pt)
{
    // check the nonce for length
    if (crypto_box_NONCEBYTES != RSTRING_LEN(nonce)) {
        rb_raise(rb_eArgError, "Nonce must be %d bytes long.", crypto_box_NONCEBYTES);
    }
    // pad our message appropriately
    VALUE plain = rb_str_new(0, crypto_box_ZEROBYTES);
    memset(RSTRING_PTR(plain), 0, crypto_box_ZEROBYTES);
    plain = rb_str_concat(plain, pt);

    // get k
    VALUE k = Crypto_Boxer_beforenm(self);

    // encrypt
    VALUE ct = rb_str_new(0, RSTRING_LEN(plain));
    int ret = crypto_box_afternm(RSTRING_PTR(ct), RSTRING_PTR(plain), RSTRING_LEN(plain), RSTRING_PTR(nonce), RSTRING_PTR(k));
    if (ret != 0) { // this should never happen, but just in case!
        rb_raise(cCrypto_CryptoError, "Encryption failed");
    }
    // strip off the pad before we return it!
    return rb_str_new(RSTRING_PTR(ct) + crypto_box_BOXZEROBYTES, RSTRING_LEN(plain) - crypto_box_BOXZEROBYTES);
}

static VALUE Crypto_Boxer_unbox(VALUE self, VALUE nonce, VALUE ct)
{
    // check the nonce for length
    if (crypto_box_NONCEBYTES != RSTRING_LEN(nonce)) {
        rb_raise(rb_eArgError, "Nonce must be %d bytes long.", crypto_box_NONCEBYTES);
    }
    // pad our message appropriately
    VALUE c = rb_str_new(0, crypto_box_BOXZEROBYTES);
    memset(RSTRING_PTR(c), 0, crypto_box_BOXZEROBYTES);
    c = rb_str_concat(c, ct);

    // get k
    VALUE k = Crypto_Boxer_beforenm(self);

    // encrypt
    VALUE mt = rb_str_new(0, RSTRING_LEN(c));
    int ret = crypto_box_open_afternm(RSTRING_PTR(mt), RSTRING_PTR(c), RSTRING_LEN(c), RSTRING_PTR(nonce), RSTRING_PTR(k));
    if (ret != 0) {
        rb_raise(cCrypto_CryptoError, "Decryption failed. Ciphertext failed verification.");
    }

    // strip off the pad before we return it!
    return rb_str_new(RSTRING_PTR(mt) + crypto_box_ZEROBYTES, RSTRING_LEN(c) - crypto_box_ZEROBYTES);
}
