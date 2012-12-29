/*
 * Copyright (c) 2012 Tony Arcieri. Distributed under the MIT License. See
 * LICENSE.txt for further details.
 */

#include "ruby.h"

static VALUE mCrypto = Qnil;
static VALUE Crypto_random_bytes(VALUE self, VALUE size);

void Init_rbnacl_ext()
{
  mCrypto = rb_define_module("Crypto");

  rb_define_singleton_method(mCrypto, "random_bytes", Crypto_random_bytes, 1);
}

static VALUE Crypto_random_bytes(VALUE self, VALUE length)
{
  int clen = NUM2INT(length);

  VALUE str = rb_str_new(0, clen);
  randombytes(RSTRING_PTR(str), clen);
  return str;
}