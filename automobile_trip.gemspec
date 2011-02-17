# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "automobile_trip/version"

Gem::Specification.new do |s|
  s.name = %q{automobile_trip}
  s.version = BrighterPlanet::AutomobileTrip::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2011-02-14}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of an automobile trip}
  s.email = %q{andy@rossmeissl.net}
  s.homepage = %q{http://github.com/brighterplanet/automobile_trip}
  s.rdoc_options = ["--charset=UTF-8"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'sniff', "~> 0.6"
  s.add_development_dependency 'fastercsv'
  s.add_runtime_dependency 'emitter', "~> 0.4.1"
  s.add_runtime_dependency 'earth', '~> 0.6.1'
  s.add_runtime_dependency 'geokit'
end

