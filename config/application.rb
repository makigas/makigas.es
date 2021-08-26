require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Makigas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Configure internationalization. What if one day I translate my channel?
    config.i18n.default_locale = :es
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.yml')]

    # Configure exceptions to show our custom /404 and /500 pages.
    config.exceptions_app = routes
  end
end
