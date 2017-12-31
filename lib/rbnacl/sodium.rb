# encoding: binary
# frozen_string_literal: true

require "ffi"

module RbNaCl
  # Provides helpers for defining the libsodium bindings
  module Sodium
    def self.extended(klass)
      klass.extend FFI::Library
      if defined?(RBNACL_LIBSODIUM_GEM_LIB_PATH)
        klass.ffi_lib RBNACL_LIBSODIUM_GEM_LIB_PATH
      else
        klass.ffi_lib "sodium"
      end
    end

    def sodium_type(type = nil)
      return @type if type.nil?
      @type = type
    end

    def sodium_primitive(primitive = nil)
      return @primitive if primitive.nil?
      @primitive = primitive
    end

    def primitive
      sodium_primitive
    end

    def sodium_type_primitive_constant(constant, name = constant)
      fn = "crypto_#{sodium_type}_#{sodium_primitive}_#{constant.to_s.downcase}"
      _generic_constant(fn, name)
    end

    def sodium_type_constant(constant, name = constant)
      fn = "crypto_#{sodium_type}_#{constant.to_s.downcase}"
      _generic_constant(fn, name)
    end

    def sodium_function(name, function, arguments)
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        ret = #{function}(*args)
        ret == 0
      end
      RUBY
    end

    def sodium_function_with_return_code(name, function, arguments)
      module_eval <<-RUBY, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        #{function}(*args)
      end
      RUBY
    end

    # this alias exists to ensure we have a stable API
    # remove for 6.0
    alias sodium_constant sodium_type_primitive_constant

    private
    def _generic_constant(fn, name)
      attach_function fn, [], :size_t
      const_set(name, public_send(fn))
    end
  end
end
