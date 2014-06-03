$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "valogy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  spec.name        = "valogy"
  spec.version     = Valogy::VERSION
  spec.authors     = ["Sascha Graef"]
  spec.email       = ["sgraef@informatik.uni-bremen.de"]
  spec.homepage    = ""
  spec.summary     = "Validate objects via OWL ontology"
  spec.description = ""

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.2"
  spec.add_dependency "pg"

  spec.add_development_dependency "bundler", ">= 1.5.3", "< 1.7.0"
  spec.add_development_dependency "rake", "~> 10.2"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pry", "~> 0.9"
end
