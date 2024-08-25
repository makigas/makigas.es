# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

DOMAINS = {
  'production' => '.makigas.es',
  'development' => '.lvh.me'
}.freeze

Rails.application.config.session_store :cookie_store, key: '_makigas_session', domain: DOMAINS[Rails.env] || :all
