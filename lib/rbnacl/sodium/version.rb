require 'rbnacl/sodium'

module RbNaCl
  module Sodium
    module Version
      MINIMUM_LIBSODIUM_VERSION = "0.4.3"

      extend Sodium
      attach_function :sodium_version_string, [], :string

      STRING = sodium_version_string
      MAJOR, MINOR, PATCH = STRING.split(".").map(&:to_i)

      installed_version = [MAJOR, MINOR, PATCH]
      minimum_version   = MINIMUM_LIBSODIUM_VERSION.split(".").map(&:to_i)

      case installed_version <=> minimum_version
      when -1
        raise "Sorry, you need to install libsodium #{MINIMUM_LIBSODIUM_VERSION}+. You have #{Version::STRING} installed"
      end
    end
  end
end
