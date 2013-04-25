# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'authorized_rails_scaffolds/version'

Gem::Specification.new do |spec|
  spec.name          = "authorized_rails_scaffolds"
  spec.version       = AuthorizedRailsScaffolds::VERSION
  spec.authors       = ["bmorrall"]
  spec.email         = ["bemo56@hotmail.com"]
  spec.description   = %q{Creates scaffolds for Twitter Bootstrap with generated RSpec coverage}
  spec.summary       = %q{Replaces Rails and RSpec's default generators with templates taking full advantage of Authentication (Devise), Authorization (CanCan) and Test Coverage (RSpec)}
  spec.homepage      = "https://github.com/bmorrall/authorized_rails_scaffolds"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'railties', '>= 3.1'
  spec.add_development_dependency "rails", '>= 3.1'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
end
