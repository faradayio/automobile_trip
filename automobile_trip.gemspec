# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{automobile_trip}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2010-09-09}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of an automobile trip}
  s.email = %q{andy@rossmeissl.net}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    "LICENSE",
     "README.rdoc",
     "lib/automobile_trip.rb",
     "lib/automobile_trip/carbon_model.rb",
     "lib/automobile_trip/characterization.rb",
     "lib/automobile_trip/data.rb",
     "lib/automobile_trip/summarization.rb"
  ]
  s.homepage = %q{http://github.com/brighterplanet/automobile_trip}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A carbon model}
  s.test_files = [
    "features/support/env.rb",
     "features/automobile_trip_committees.feature",
     "features/automobile_trip_emissions.feature"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
      s.add_development_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_development_dependency(%q<jeweler>, ["= 1.4.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
      s.add_development_dependency(%q<sniff>, ["= 0.0.11"])
      s.add_runtime_dependency(%q<emitter>, [">= 0.0.1"])
    else
      s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
      s.add_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
      s.add_dependency(%q<cucumber>, ["= 0.8.3"])
      s.add_dependency(%q<jeweler>, ["= 1.4.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
      s.add_dependency(%q<sniff>, ["= 0.0.11"])
      s.add_dependency(%q<emitter>, [">= 0.0.1"])
    end
  else
    s.add_dependency(%q<activerecord>, ["= 3.0.0.beta4"])
    s.add_dependency(%q<bundler>, [">= 1.0.0.beta.2"])
    s.add_dependency(%q<cucumber>, ["= 0.8.3"])
    s.add_dependency(%q<jeweler>, ["= 1.4.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["= 2.0.0.beta.17"])
    s.add_dependency(%q<sniff>, ["= 0.0.11"])
    s.add_dependency(%q<emitter>, [">= 0.0.1"])
  end
end
