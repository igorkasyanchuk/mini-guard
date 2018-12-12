
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mini/guard/version"

Gem::Specification.new do |spec|
  spec.name          = "mini-guard"
  spec.version       = Mini::Guard::VERSION
  spec.authors       = ["Igor Kasyanchuk"]
  spec.email         = ["igorkasyanchuk@gmail.com"]

  spec.summary       = %q{Very simple rspec specs executor.}
  spec.description   = %q{Run specs when you edit your files in a smart way (in app, views, specs folder).}
  spec.homepage      = "https://github.com/igorkasyanchuk/mini-guard"
  spec.license       = "MIT"

  spec.files         = Dir["{lib,spec}/**/*", "Gemfile", "Gemfile.lock", "MIT-LICENSE", "Rakefile", "README.rdoc", "bin/mg"]

  spec.executables   = ["mg", "mini-guard"]
  spec.bindir        = "bin"
  spec.require_paths = ["lib", "bin"]

  spec.add_runtime_dependency "rake"
  spec.add_runtime_dependency "listen"
  spec.add_runtime_dependency "shellany"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
