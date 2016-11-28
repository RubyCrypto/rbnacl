require "rbnacl/sodium"

module RbNaCl
  module Sodium
    # libsodium version API
    module Version
      MINIMUM_LIBSODIUM_VERSION = [0, 4, 3].freeze
      MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2 = [1, 0, 9].freeze

      extend Sodium
      attach_function :sodium_version_string, [], :string

      STRING = sodium_version_string
      MAJOR, MINOR, PATCH = STRING.split(".").map(&:to_i)

      INSTALLED_VERSION = [MAJOR, MINOR, PATCH].freeze

      case INSTALLED_VERSION <=> MINIMUM_LIBSODIUM_VERSION
      when -1
        raise "Sorry, you need to install libsodium #{MINIMUM_LIBSODIUM_VERSION}+. You have #{Version::STRING} installed"
      end

      ARGON2_SUPPORTED = (INSTALLED_VERSION <=> MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2) == -1 ? false : true
    end
  end
end
