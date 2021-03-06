# -*- ruby -*-
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghwikitools/version'

Gem::Specification.new do |spec|
  spec.name          = "ghwikitools"
  spec.version       = GHWikiTools::VERSION
  spec.authors       = ["Keita Yamaguchi"]
  spec.email         = ["keita.yamaguchi@gmail.com"]
  spec.description   = "GitHub wiki management tools."
  spec.summary       = "GitHub wiki management tools."
  spec.homepage      = "https://github.com/keita/ghwikitools"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "iso-639"
  spec.add_dependency "thor"
  spec.add_dependency "forwardablex"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet" unless RUBY_PLATFORM == 'java'
  spec.add_development_dependency "bacon"
  spec.add_development_dependency "temppath"
end
