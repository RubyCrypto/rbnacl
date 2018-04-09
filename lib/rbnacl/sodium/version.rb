# encoding: binary
# frozen_string_literal: true

require "rbnacl/sodium"

module RbNaCl
  module Sodium
    # libsodium version API
    module Version
      MINIMUM_LIBSODIUM_VERSION = [0, 4, 3].freeze
      MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2 = [1, 0, 9].freeze
      MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2ID = [1, 0, 13].freeze

      extend Sodium
      attach_function :sodium_version_string, [], :string

      STRING = sodium_version_string
      MAJOR, MINOR, PATCH = STRING.split(".").map(&:to_i)

      INSTALLED_VERSION = [MAJOR, MINOR, PATCH].freeze

      case INSTALLED_VERSION <=> MINIMUM_LIBSODIUM_VERSION
      when -1
        raise "Sorry, you need to install libsodium #{MINIMUM_LIBSODIUM_VERSION}+. You have #{Version::STRING} installed"
      end

      ARGON2_SUPPORTED = (INSTALLED_VERSION <=> MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2) != -1
      ARGON2ID_SUPPORTED = (INSTALLED_VERSION <=> MINIMUM_LIBSODIUM_VERSION_FOR_ARGON2ID) != -1

      # Determine if a given feature is supported based on Sodium version
      def self.supported_version?(version)
        Gem::Version.new(sodium_version_string) >= Gem::Version.new(version)
      end
    end
  end
end
