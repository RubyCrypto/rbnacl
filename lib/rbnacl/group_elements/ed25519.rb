# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module GroupElements
    # Points on the Ed25519 elliptic curve
    #
    # This class provides low-level operations on Ed25519 curve points,
    # including point validation.
    class Ed25519
      extend Sodium

      sodium_type :core
      sodium_primitive :ed25519

      sodium_function_with_return_code :core_ed25519_is_valid_point,
                                        :crypto_core_ed25519_is_valid_point,
                                        %i[pointer]

      # Number of bytes in an Ed25519 point
      BYTES = 32

      # Check if a point is valid on the Ed25519 curve
      #
      # @param point [String] The point to validate (32 bytes)
      #
      # @raise [LengthError] if the point is not 32 bytes
      #
      # @return [Boolean] true if the point is valid, false otherwise
      def self.valid_point?(point)
        point = point.to_str
        Util.check_length(point, BYTES, "point")
        core_ed25519_is_valid_point(point).zero?
      end
    end
  end
end
