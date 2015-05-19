source "https://rubygems.org"

# Declare your gem's dependencies in valogy.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'


group :test do
  # Feature-Verfahren für Akzeptanztests
  gem 'cucumber-rails', '~> 1.3', :require => false

  # Testen von Views (HTML und Javascript)
  gem 'capybara', '~> 2.0'

  # Datenbank nach Tests aufräumen
  gem 'database_cleaner', '~> 1.3.0'
	
	#launch automtically webbrowser in tests
	gem 'launchy'
end
