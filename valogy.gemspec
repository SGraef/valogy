$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "valogy/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "valogy"
  spec.version     = Valogy::VERSION
  spec.authors     = ["Sascha Graef"]
  spec.email       = ["sgraef@informatik.uni-bremen.de"]
  spec.homepage    = "https://github.com/SGraef/valogy/"
  spec.summary     = "Validate objects via OWL ontology"
  spec.description = ""

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", "~> 4.0.2"
  spec.add_dependency "pg"
  spec.add_dependency "nokogiri"
  spec.add_dependency 'activerecord', "~> 4.0"
  spec.add_dependency "activesupport", "~> 4.0"

  spec.add_development_dependency "bundler", ">= 1.5.3"
  spec.add_development_dependency "rake", "~> 10.2"
  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "pry-rails", "~> 0.3"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "coveralls", "~> 0.7.0"
end
