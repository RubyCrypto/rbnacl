# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbnacl/version'

Gem::Specification.new do |gem|
  gem.name          = "rbnacl"
  gem.version       = RbNaCl::VERSION
  gem.authors       = ["Tony Arcieri", "Jonathan Stott"]
  gem.email         = ["tony.arcieri@gmail.com", "jonathan.stott@gmail.com"]
  gem.description   = "Ruby binding to the Networking and Cryptography (NaCl) library"
  gem.summary       = "The Networking and Cryptography (NaCl) library provides a high-level toolkit for building cryptographic systems and protocols"
  gem.homepage      = "https://github.com/cryptosphere/rbnacl"
  gem.licenses    = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  if defined? JRUBY_VERSION
    gem.platform = "jruby"
  end

  gem.add_runtime_dependency "ffi"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 2.14"
  gem.add_development_dependency "rubocop"

  gem.cert_chain = ["bascule.cert"]
end
