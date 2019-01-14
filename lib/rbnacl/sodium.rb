# encoding: binary
# frozen_string_literal: true

require "ffi"

module RbNaCl
  # Provides helpers for defining the libsodium bindings
  module Sodium
    def self.extended(klass)
      klass.extend FFI::Library
      klass.ffi_lib ["sodium", "libsodium.so.18", "libsodium.so.23"]
    end

    def sodium_type(type = nil)
      return @type if type.nil?

      @type = type
    end

    def sodium_primitive(primitive = nil)
      if primitive.nil?
        @primitive if defined?(@primitive)
      else
        @primitive = primitive
      end
    end

    def primitive
      sodium_primitive
    end

    def sodium_constant(constant, name: constant, fallback: nil)
      fn_name_components = ["crypto", sodium_type, sodium_primitive, constant.to_s.downcase]
      fn_name = fn_name_components.compact.join("_")

      begin
        attach_function fn_name, [], :size_t
      rescue FFI::NotFoundError
        raise if fallback.nil?

        define_singleton_method fn_name, -> { fallback }
      end

      const_set(name, public_send(fn_name))
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
  end
end
