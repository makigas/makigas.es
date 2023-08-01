# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 3.2.0'

gem 'dotenv-rails', '~> 2.8.1'
gem 'rake', '~> 13.0.3'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.16.0'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'nokogiri', '~> 1.15.3'
gem 'pg', '~> 1.5.3'
gem 'puma', '~> 6.3.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.6'
gem 'rails-i18n', '~> 7.0.7'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Job processing
gem 'delayed_job', '~> 4.1.11'
gem 'delayed_job_active_record'
gem 'delayed_job_web'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.132.0'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'chroma'
gem 'devise'
gem 'faraday', '~> 2.7.10'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.2.0'
gem 'lookbook', '~> 2.0.5'
gem 'meilisearch-rails', '~> 0.9.1'
gem 'rails_feather'
gem 'redcarpet'
gem 'rouge'
gem 'simple_form'
gem 'sitemap_generator', '~> 6.3.0'
gem 'view_component', '~> 3.4.0'
gem 'view_component-contrib'
gem 'whenever'

# Ops
gem 'sentry-rails', '~> 5.10.0'
gem 'sentry-ruby', '~> 5.10.0'

group :development do
  # Development tools
  gem 'annotate', '~> 3.2.0'
  gem 'byebug'
  gem 'listen', '~> 3.8.0'
  gem 'web-console', '~> 4.2.0'

  # LSP
  gem 'solargraph', '~> 0.49.0'
  gem 'solargraph-rails', '~> 1.1.0'

  # Guard
  gem 'guard', '~> 2.18.0'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rubocop', '~> 1.5.0'
  gem 'guard-shell', '~> 0.7.2'

  # Lint tools
  gem 'overcommit', '~> 0.60.0', require: false
  gem 'rubocop', '~> 1.54.1', require: false
  gem 'rubocop-rails', '~> 2.20.2', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 2.22.0', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.2.0'
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 6.0.3'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.39.2'
  gem 'selenium-webdriver', '~> 4.10.0'
  gem 'webdrivers', '~> 5.2.0'
end
