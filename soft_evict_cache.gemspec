# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'soft_evict_cache/version'

Gem::Specification.new do |spec|
  spec.name          = "soft_evict_cache"
  spec.version       = SoftEvictCache::VERSION
  spec.authors       = ["Tejas Dinkar"]
  spec.email         = ["tejas@gja.in"]

  spec.summary       = %q{A Soft Evict Cache For Ruby}
  spec.homepage      = "https://github.com/gja/soft_evict_cache"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "concurrent-ruby", "~> 1.0.2"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
