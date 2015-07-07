# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'router/version'

Gem::Specification.new do |spec|
  spec.name          = "router"
  spec.version       = Router::VERSION
  spec.authors       = ["Mathias Kaufmann"]
  spec.email         = ["me@stei.gr"]

  spec.summary       = %q{Nginx Service Router}
  spec.description   = %q{Nginx Service Router}
  spec.homepage      = "https://cloud.stei.gr/router"

  spec.files         = `git ls-files -z 2>/dev/null || true`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.9"
  spec.add_dependency "docker-api", "~> 1.21"
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "colorize"
  spec.add_dependency "httparty"
  spec.add_dependency "sinatra"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.10"
end
