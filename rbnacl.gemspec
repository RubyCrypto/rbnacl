# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbnacl/version'

Gem::Specification.new do |gem|
  gem.name          = "rbnacl"
  gem.version       = Crypto::VERSION
  gem.authors       = ["Tony Arcieri"]
  gem.email         = ["tony.arcieri@gmail.com"]
  gem.description   = "Ruby binding to the Networking and Cryptography (NaCl) library"
  gem.summary       = "The Networking and Cryptography (NaCl) library provides a high-level toolkit for building cryptographic systems and protocols"
  gem.homepage      = "https://github.com/tarcieri/rbnacl"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  if defined? JRUBY_VERSION
    gem.platform = "jruby"
  else
    gem.extensions = "ext/rbnacl/extconf.rb"
  end

  gem.add_runtime_dependency 'ffi'

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rake-compiler"
  gem.add_development_dependency "rspec"
end
