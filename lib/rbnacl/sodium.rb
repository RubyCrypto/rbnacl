# encoding: binary
require 'ffi'

module RbNaCl
  # Provides helpers for defining the libsodium bindings
  module Sodium
    def self.extended(klass)
      klass.extend FFI::Library
      klass.ffi_lib 'sodium'
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

    def sodium_constant(constant, name=constant)
      fn = "crypto_#{sodium_type}_#{sodium_primitive}_#{constant.to_s.downcase}"
      attach_function fn, [], :ulong_long
      self.const_set(name, self.public_send(fn))
    end

    def sodium_function(name, function, arguments)
      self.module_eval <<-eos, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        ret = #{function}(*args)
        ret == 0
      end
      eos
    end
  end
end
