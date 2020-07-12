source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

gem "rails", "~> 6.0.3", ">= 6.0.3.2"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 4.0"
gem "jbuilder", "~> 2.7"
gem "slim-rails"
gem "jwt", ">=2.2.1"
gem "cancancan", ">=3.1.0"
gem "whenever", ">= 1.0.0"
gem "interactor", "~> 3.0" # Opinionated Result object pattern with shared context
gem "actionpack-xml_parser" # XML parameters parser for Action Pack
gem "bcrypt", "~> 3.1.7" # Use Active Model has_secure_password
# Use Active Storage variant
# gem "image_processing", "~> 1.2"

gem "bootsnap", ">= 1.4.2", require: false # Reduces boot times through caching; required in config/boot.rb

group :development, :test do
  gem "equivalent-xml"
  gem "ori", ">= 0.1.0"
  gem "factory_bot_rails"
  gem "faker", ">= 2.13.0"
  gem "rspec-rails", "~> 4.0.0"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw] # Call "byebug" anywhere in the code to stop execution and get a debugger console
end

group :development do
  gem "web-console", ">= 3.3.0" # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "listen", "~> 3.2"
  gem "spring" # Spring speeds up development by keeping your application running in the background.
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "capybara", ">= 2.15" # Adds support for Capybara system testing and selenium driver
  gem "selenium-webdriver"
  gem "webdrivers" # Easy installation and use of web drivers to run system tests with browsers
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
