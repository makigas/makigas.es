# frozen_string_literal: true

source 'https://beta.gem.coop'

ruby '~> 3.3.0'

gem 'dotenv-rails', '~> 3.2.0'
gem 'rake', '~> 13.4.2'

# Base Ruby on Rails distribution
gem 'bootsnap', '~> 1.25.0'
gem 'jbuilder', '~> 2.15.1'
gem 'jsbundling-rails'
gem 'nokogiri', '~> 1.19.4'
gem 'pg', '~> 1.6.3'
gem 'puma', '~> 8.0.2'
gem 'rack-cors'
gem 'rails', '~> 7.2', '< 7.3.0'
gem 'rails-i18n', '~> 7.0.7'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'

# Job processing
gem 'delayed_job', '~> 4.2.0'
gem 'delayed_job_active_record'
gem 'delayed_job_web'

# Application extras
gem 'acts_as_list'
gem 'aws-sdk-s3', '~> 1.159.0'
gem 'blueprinter'
gem 'bootstrap-kaminari-views', '~> 0.0.5'
gem 'chroma'
gem 'devise'
gem 'faraday', '~> 2.10.1'
gem 'friendly_id'
gem 'haml-rails', '~> 2.0'
gem 'kaminari'
gem 'kt-paperclip', '~> 8.0.0'
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
  gem 'overcommit', '~> 0.72.0', require: false
  gem 'rubocop', '~> 1.89.0', require: false
  gem 'rubocop-capybara', '~> 3.0.0', require: false
  gem 'rubocop-factory_bot', '~> 2.28.0', require: false
  gem 'rubocop-rails', '~> 2.37.0', require: false
  gem 'rubocop-rake', '~> 0.7.1', require: false
  gem 'rubocop-rspec', '~> 3.10.2', require: false
  gem 'rubocop-rspec_rails', '~> 2.32.0', require: false
end

# Test tools that must be available in development mode
group :development, :test do
  gem 'factory_bot', '~> 6.6.0'
  gem 'factory_bot_rails', '~> 6.5.1'
  gem 'fuubar'
  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 7.1.1'
end

# Test tools
group :test do
  gem 'capybara', '~> 3.40.0'
  gem 'capybara-screenshot', '~> 1.0.27'
  gem 'selenium-webdriver', '~> 4.47.0'
end
