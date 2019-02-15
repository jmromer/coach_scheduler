# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.3"

gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", "~> 4.2.1"
gem "graphql"
gem "jbuilder", "~> 2.5"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.2"
gem "sass-rails", "~> 5.0"
gem "webpacker"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "bundler-gtags"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rufo"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :development, :test do
  gem "factory_bot_rails", "~> 4.0"
  gem "hirb"
  gem "jazz_fingers"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails"
  gem "vcr"
  gem "webmock"
end

group :test do
  gem "capybara"
  gem "rails-controller-testing"
  gem "shoulda-matchers", "4.0.0.rc1"
  gem "timecop"
end

group :development do
  gem "spring-commands-rspec"
end

gem "graphiql-rails", group: :development
