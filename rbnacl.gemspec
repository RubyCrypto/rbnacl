# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rbnacl/version"

Gem::Specification.new do |spec|
  spec.name          = "rbnacl"
  spec.version       = RbNaCl::VERSION
  spec.authors       = ["Tony Arcieri", "Jonathan Stott"]
  spec.email         = ["bascule@gmail.com", "jonathan.stott@gmail.com"]
  spec.homepage      = "https://github.com/cryptosphere/rbnacl"
  spec.licenses      = ["MIT"]
  spec.summary       = "Ruby binding to the Networking and Cryptography (NaCl) library"
  spec.description = <<-DESCRIPTION.strip.gsub(/\s+/, " ")
    The Networking and Cryptography (NaCl) library provides a high-level toolkit for building
    cryptographic systems and protocols
  DESCRIPTION

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.6"
  spec.platform = "jruby" if defined? JRUBY_VERSION

  spec.add_runtime_dependency "ffi"

  spec.add_development_dependency "bundler"
end
