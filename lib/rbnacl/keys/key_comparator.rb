module Crypto
  # Implements comparisons of keys
  #
  # This permits both timing invariant equality tests, as well as
  # lexicographical sorting.
  module KeyComparator
    include Comparable
    # spaceship operator
    #
    # @param other [KeyComparator,#to_str] The thing to compare
    #
    # @return [0] if the keys are equal
    # @return [1] if the key is larger than the other key
    # @return [-1] if the key is smaller than the other key
    # @return [nil] if comparison doesn't make sense
    def <=>(other)
      if KeyComparator > other.class
        other = other.to_bytes
      elsif other.respond_to?(:to_str)
        other = other.to_str
      else
        return nil
      end

      if Util.verify32(self.to_bytes, other)
        return 0
      elsif self.to_bytes > other
        return 1
      else
        return -1
      end
    end
  end
end
