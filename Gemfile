# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.0.0'

gem 'rake', '~> 13.0.3'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.10.1'
gem 'dotenv-rails'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'meilisearch-rails'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.5.2'
gem 'rack-cors'
gem 'rails', '6.1.4.4'
gem 'rails-i18n', '~> 6.0.0'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.111.1'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'devise'
gem 'faraday', '< 2.0.0'
gem 'faraday_middleware', '~> 1.2.0'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.0.1'
gem 'lookbook'
gem 'rails_feather'
gem 'redcarpet'
gem 'simple_form'
gem 'sitemap_generator', '~> 6.2.1'
gem 'view_component', '~> 2.48.0'
gem 'view_component-contrib'
gem 'whenever'

# Ops
gem 'sentry-rails', '~> 4.9.2'
gem 'sentry-ruby', '~> 4.9.2'

group :development do
  # Development tools
  gem 'byebug'
  gem 'listen', '~> 3.7.1'
  gem 'web-console', '~> 4.2.0'

  # Guard
  gem 'guard', '~> 2.18.0'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rubocop', '~> 1.5.0'

  # Lint tools
  gem 'rubocop', '~> 1.25.0', require: false
  gem 'rubocop-rails', '~> 2.13.2', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.7.0', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.2.0'
  gem 'factory_bot_rails'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 5.0.2'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.36.0'
  gem 'selenium-webdriver', '~> 4.1.0'
  gem 'webdrivers', '~> 5.0.0'
end
