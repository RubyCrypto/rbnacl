# encoding: binary
module RbNaCl
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

    # equality operator
    #
    # The equality operator is explicity defined, despite including Comparable
    # and having a spaceship operator, so that if equality tests are desired,
    # they can be timing invariant, without any chance that the further
    # comparisons for greater than and less than can leak information.  Maybe
    # this is too paranoid, but I don't know how ruby works under the hood with
    # comparable.
    #
    # @param other [KeyComparator,#to_str] The thing to compare
    #
    # @return [true] if the keys are equal
    # @return [false] if they keys are not equal
    def ==(other)
      if KeyComparator > other.class
        other = other.to_bytes
      elsif other.respond_to?(:to_str)
        other = other.to_str
      else
        return false
      end
      Util.verify32(self.to_bytes, other)
    end
  end
end
