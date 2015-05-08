# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doughnut/version'

Gem::Specification.new do |spec|
  spec.name          = "doughnut"
  spec.version       = Doughnut::VERSION
  spec.authors       = ["Cyrus Vandrevala"]
  spec.email         = ["cyrus.vandrevala@gmail.com"]
  spec.summary       = %q{Generate statistics for a personal portfolio.}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "descriptive_statistics"
end
