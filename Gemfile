# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.0.0'

gem 'rake', '~> 13.0.3'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.8.0'
gem 'dotenv-rails'
gem 'jbuilder', '~> 2.11'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.4.0'
gem 'rails', '6.1.4.1'
gem 'rails-i18n', '~> 6.0.0'
gem 'sass-rails', '~> 6.0'
gem 'sdoc', '~> 2.2.0', group: :doc
gem 'uglifier', '>= 1.3.0'
gem 'webpacker', '~> 5.4.3'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.99.0'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'devise'
gem 'faraday', '~> 1.7.0'
gem 'faraday_middleware', '~> 1.1.0'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.0.0'
gem 'redcarpet'
gem 'simple_form'
gem 'sitemap_generator'
gem 'whenever'

group :development do
  # Development tools
  gem 'byebug'
  gem 'listen', '~> 3.5'
  gem 'web-console', '~> 4.1.0'

  # Lint tools
  gem 'rubocop', '~> 1.20.0', require: false
  gem 'rubocop-rails', '~> 2.11.3', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.4', require: false
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
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.6.1'
end
