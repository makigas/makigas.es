# frozen_string_literal: true

source 'https://gem.coop'

ruby '~> 3.3.0'

gem 'dotenv-rails', '~> 3.1.0'
gem 'rake', '~> 13.2.1'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.18.3'
gem 'jbuilder', '~> 2.11'
gem 'jsbundling-rails'
gem 'nokogiri', '~> 1.16.2'
gem 'pg', '~> 1.5.3'
gem 'puma', '~> 6.4.0'
gem 'rack-cors'
gem 'rails', '~> 7.2', '< 7.3.0'
gem 'rails-i18n', '~> 7.0.7'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Job processing
gem 'delayed_job', '~> 4.1.11'
gem 'delayed_job_active_record'
gem 'delayed_job_web'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.208.0'
gem 'blueprinter'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'chroma'
gem 'devise'
gem 'faraday', '~> 2.10.1'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 7.2.0'
gem 'lookbook', '~> 2.3.2'
gem 'meilisearch-rails', '~> 0.16.0'
gem 'rails_feather'
gem 'redcarpet'
gem 'rouge'
gem 'simple_form'
gem 'sitemap_generator', '~> 6.3.0'
gem 'view_component', '~> 3.13.0'
gem 'view_component-contrib'

# Ops
gem 'sentry-rails', '~> 5.19.0'
gem 'sentry-ruby', '~> 5.19.0'

group :development do
  # Development tools
  gem 'annotate', '~> 3.2.0'
  gem 'byebug'
  gem 'listen', '~> 3.9.0'
  gem 'web-console', '~> 4.2.0'

  # Guard
  gem 'guard', '~> 2.18.0'
  gem 'guard-rails', '~> 0.8.1'
  gem 'guard-rspec', '~> 4.7.3'
  gem 'guard-rubocop', '~> 1.5.0'
  gem 'guard-shell', '~> 0.7.2'

  # Lint tools
  gem 'overcommit', '~> 0.64.0', require: false
  gem 'rubocop', '~> 1.65.1', require: false
  gem 'rubocop-capybara', '~> 2.21.0', require: false
  gem 'rubocop-factory_bot', '~> 2.26.1', require: false
  gem 'rubocop-rails', '~> 2.26.0', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 3.0.4', require: false
  gem 'rubocop-rspec_rails', '~> 2.30.0', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.4.6'
  gem 'factory_bot_rails', '~> 6.4.3'
  gem 'fuubar'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails', '~> 6.1.1'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.40.0'
  gem 'capybara-screenshot', '~> 1.0.26'
  gem 'selenium-webdriver', '~> 4.23.0'
end
