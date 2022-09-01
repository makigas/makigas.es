# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.1.0'

gem 'dotenv-rails', '~> 2.8.1'
gem 'rake', '~> 13.0.3'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.13.0'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'meilisearch-rails'
gem 'pg', '~> 1.4.3'
gem 'puma', '~> 5.6.5'
gem 'rack-cors'
gem 'rails', '~> 7.0.3'
gem 'rails-i18n', '~> 7.0.0'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Job processing
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'delayed_job_web'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.114.0'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'chroma'
gem 'devise'
gem 'faraday', '~> 2.5.1'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.1.1'
gem 'lookbook', '~> 0.9.3'
gem 'rails_feather'
gem 'redcarpet'
gem 'simple_form'
gem 'sitemap_generator', '~> 6.3.0'
gem 'view_component', '~> 2.66.0'
gem 'view_component-contrib'
gem 'whenever'

# Ops
gem 'sentry-rails', '~> 5.4.1'
gem 'sentry-ruby', '~> 5.4.1'

group :development do
  # Development tools
  gem 'annotate', '~> 3.2.0'
  gem 'byebug'
  gem 'listen', '~> 3.7.1'
  gem 'web-console', '~> 4.2.0'

  # LSP
  gem 'solargraph', '~> 0.45.0'
  gem 'solargraph-rails', '~> 0.3.1'

  # Guard
  gem 'guard', '~> 2.18.0'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rubocop', '~> 1.5.0'
  gem 'guard-shell', '~> 0.7.2'

  # Lint tools
  gem 'overcommit', '~> 0.59.1', require: false
  gem 'rubocop', '~> 1.34.1', require: false
  gem 'rubocop-rails', '~> 2.15.2', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.12.1', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.2.0'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 5.1.2'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.37.1'
  gem 'selenium-webdriver', '~> 4.4.0'
  gem 'webdrivers', '~> 5.0.0'
end
