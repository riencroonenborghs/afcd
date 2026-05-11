source "https://rubygems.org"

gem "rails", "~> 7.2.3", ">= 7.2.3.1"
gem "sprockets-rails"
gem "sqlite3", ">= 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "fast-mcp", "~> 1.6"
gem "dotenv-rails", "~> 3.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "annotaterb", "~> 4.22"
  gem "awesome_print", "~> 1.9"
  gem "roo", "~> 3.0"
end

group :development do
  gem "web-console"
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'        # or capistrano-rvm depending on your ruby manager
  gem "capistrano3-puma", "~> 8.0"
  gem 'capistrano-nvm', require: false

  # capistrano
  gem "ed25519", "~> 1.4" 
  gem "bcrypt_pbkdf", "~> 1.1"
end
