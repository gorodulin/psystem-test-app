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
gem "cancancan"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"
# Use Active Storage variant
# gem "image_processing", "~> 1.2"

gem "bootsnap", ">= 1.4.2", require: false # Reduces boot times through caching; required in config/boot.rb

group :development, :test do
  gem "factory_bot_rails"
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
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
