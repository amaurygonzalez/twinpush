# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "twinpush"
  s.version     = "0.0.4"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Amaury González"]
  s.email       = ["amaury.muro@gmail.com"]
  s.homepage    = "https://github.com/amaurygonzalez/twinpush"
  s.summary     = %q{Reliably deliver push notifications through TwinPush API}
  s.description = %q{TwinPush gem provides ruby bindings to TwinPush a messaging solution that lets you reliably deliver messages and notifications at no cost to Android, iOS or Web browsers.}
  s.license     = "MIT"

  s.required_ruby_version     = '>= 2.0.0'

  s.rubyforge_project = "twinpush"

  s.files         = ["lib/twinpush.rb"]
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_runtime_dependency('faraday','>= 0.12.2')
end
