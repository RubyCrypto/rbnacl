module Crypto
  # Encoders can be used to serialize or deserialize keys, ciphertexts, hashes,
  # and signatures. To provide an encoder, simply subclass Encoder and call the
  # register class method, then define the encode and decode methods:
  #
  #     class CrazysauceEncoder < Crypto::Encoder
  #       register :crazysauce
  #
  #       def encode(string)
  #         ...
  #       end
  #
  #       def decode(string)
  #         ...
  #       end
  #     end
  #
  # Once an encoder has been registered, an instance of it is available via
  # calling Crypto::Encoder[], e.g. Crypto::Encoder[:hex].encode("foobar")
  #
  class Encoder
    # Hash where encoder objects are stored
    Registry = {}

    # Register the current class as an encoder
    def self.register(name)
      self[name] = self.new
    end

    # Look up an encoder by the given name
    def self.[](name)
      Registry[name.to_sym] or raise ArgumentError, "unsupported encoder: #{name}"
    end

    # Register an encoder object directly
    def self.[]=(name, obj)
      Registry[name.to_sym] = obj
    end

    def encode(string); raise NotImplementedError, "encoding not implemented"; end
    def decode(string); raise NotImplementedError, "decoding not implemented"; end
  end
end
