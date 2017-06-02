# encoding: binary
# frozen_string_literal: true

module RbNaCl
  module Hash
    class Blake2bState < FFI::Struct
      layout :h, [:uint64, 8],
             :t, [:uint64, 2],
             :f, [:uint64, 2],
             :buf, [:uint8, 2 * 128],
             :buflen, :size_t,
             :last_node, :uint8
    end
  end
end
