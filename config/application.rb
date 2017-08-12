require_relative 'boot'
require_relative '../lib/makigas/version_header'
require_relative '../lib/makigas/revision_header'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Makigas
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << "#{Rails.root}/lib"

    # Configure internationalization. What if one day I translate my channel?
    config.i18n.default_locale = :es
    config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.yml"]

    # Extra middleware
    config.middleware.use Makigas::VersionHeader
    config.middleware.use Makigas::RevisionHeader
  end
end
