require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Makigas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Configure internationalization. What if one day I translate my channel?
    config.i18n.default_locale = :es
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml')]

    # Configure exceptions to show our custom /404 and /500 pages.
    config.exceptions_app = routes

    # Configure Delayed Job
    config.active_job.queue_adapter = :delayed_job
  end
end
