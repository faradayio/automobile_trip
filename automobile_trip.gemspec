# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "automobile_trip/version"

Gem::Specification.new do |s|
  s.name = %q{automobile_trip}
  s.version = BrighterPlanet::AutomobileTrip::VERSION

  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2011-02-21}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of an automobile trip}
  s.email = %q{andy@rossmeissl.net}
  s.homepage = %q{http://github.com/brighterplanet/automobile_trip}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = [
    "LICENSE",
     "LICENSE-PREAMBLE",
     "README.rdoc"
  ]
  s.require_paths = ["lib"]
  s.rdoc_options = ["--charset=UTF-8"]

  s.add_development_dependency 'sniff'
  s.add_runtime_dependency 'emitter'
end

