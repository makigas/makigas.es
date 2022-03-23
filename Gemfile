# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.0.0'

gem 'dotenv-rails', '~> 2.7.6'
gem 'rake', '~> 13.0.3'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.11.1'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'meilisearch-rails'
gem 'pg', '~> 1.2'
gem 'puma', '~> 5.6.2'
gem 'rack-cors'
gem 'rails', '~> 7.0.0'
gem 'rails-i18n', '~> 7.0.0'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Job processing
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed_job_web'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.113.0'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'chroma'
gem 'devise'
gem 'faraday', '~> 2.2.0'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.1.1'
gem 'lookbook'
gem 'rails_feather'
gem 'redcarpet'
gem 'simple_form'
gem 'sitemap_generator', '~> 6.2.1'
gem 'view_component', '~> 2.50.0'
gem 'view_component-contrib'
gem 'whenever'

# Ops
gem 'sentry-rails', '~> 5.2.0'
gem 'sentry-ruby', '~> 5.2.0'

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
  gem 'guard-shell', '~> 0.7.2'

  # Lint tools
  gem 'rubocop', '~> 1.26.0', require: false
  gem 'rubocop-rails', '~> 2.14.1', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.9.0', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.2.0'
  gem 'factory_bot_rails'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 5.1.1'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.36.0'
  gem 'selenium-webdriver', '~> 4.1.0'
  gem 'webdrivers', '~> 5.0.0'
end
