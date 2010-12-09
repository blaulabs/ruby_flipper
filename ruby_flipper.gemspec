# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "ruby_flipper"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Thomas Jachmann"]
  s.email       = ["self@thomasjachmann.com"]
  s.homepage    = "https://github.com/blaulabs/ruby_flipper"
  s.summary     = %q{Make switching features on and off easy.}
  s.description = %q{Most flexible still least verbose feature flipper for ruby projects.}

  s.rubyforge_project = "ruby_flipper"

  s.add_development_dependency "ci_reporter", "~> 1.6.3"
  s.add_development_dependency "rspec", "~> 2.0.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
