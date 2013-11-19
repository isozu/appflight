# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require File.expand_path('../lib/appflight/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = "appflight"
  gem.authors     = ["Masaaki Isozu"]
  gem.email       = "m.isozu@gmail.com"
  gem.license     = "MIT"
  gem.version     = AppFlight::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.summary     = "AppFlight"
  gem.description = "Release .ipa file on cloud storage for distribution like TestFlight."
  gem.homepage    = "https://github.com/isozu/appflight"

  gem.add_dependency "shenzhen", "~> 0.5.1"
  gem.add_dependency "commander", "~> 4.1"
  gem.add_dependency "dotenv", "~> 0.7"
  gem.add_dependency "aws-sdk", "~> 1.0"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"

  gem.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]
end
