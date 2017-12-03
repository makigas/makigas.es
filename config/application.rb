require_relative 'boot'

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

    if ENV["RAILS_USE_S3"].present?
      # Base settings, they work on all cases.
      config.paperclip_defaults = {
        storage: :s3,
        s3_credentials: {
          bucket: ENV['S3_BUCKET_NAME'],
          region: ENV.fetch('AWS_REGION') { 'us-east-1' },
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_key_id: ENV['AWS_SECRET_KEY_ID']
        }
      }

      # Use custom host as primary (s3-us-west-2 instead of s3, for instance).
      # URL before:            s3.amazonaws.com/cdn.makigas.es/hi.css
      # URL after:   s3-us-west-2.amazonaws.com/cdn.makigas.es/hi.css
      Paperclip::Attachment.default_options[:s3_host_name] = ENV['S3_HOST_NAME'] if ENV['S3_HOST_NAME'].present?

      # Put the bucket in the domain if this env is set to any value.
      # URLs will be like cdn.makigas.es.s3.amazonaws.com/hi.css
      # instead of s3.amazonaws.com/cdn.makigas.es/hi.css
      # Domain name acts as bucket. This block has two use cases:
      # 1. Use bucket name in subdomain, as cdn.makigas.es.s3.amazonaws.com.
      #    Set S3_BUCKET_DOMAIN env variable to any value to enable this.
      #    URL before:    s3.amazonaws.com/cdn.makigas.es/hi.css
      #    URL after:     cdn.makigas.es.s3.amazonaws.com/hi.css
      # 2. Use an alias domain, as cdn.makigas.es Set S3_HOST_ALIAS to the
      #    host alias to use as domain to enable this.
      #    URL before:    s3.amazonaws.com/cdn.makigas.es/hi.css
      #    URL after:     cdn.makigas.es/hi.css
      #    S3_HOST_ALIAS is set to cdn.makigas.es. Usually this domain will
      #    have a CNAME pointing to the bucket domain, although this block
      #    won't care about it as the purpose here is to set the URLs.
      if ENV['S3_BUCKET_DOMAIN'].present? || ENV['S3_HOST_ALIAS'].present?
        Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
        if ENV['S3_HOST_ALIAS'].present?
          Paperclip::Attachment.default_options[:s3_host_alias] = ENV['S3_HOST_ALIAS']
          Paperclip::Attachment.default_options[:url] = ':s3_alias_url'
        else
          Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
        end
      end

      # Use a custom endpoint (for instance, Minio or other S3-like APIs)
      if ENV['S3_ENDPOINT'].present?
        Paperclip::Attachment.default_options[:s3_region] = ENV.fetch('AWS_REGION') { 'us-east-1' }
        Paperclip::Attachment.default_options[:s3_options] = {
          force_path_style: true,
          endpoint: ENV['S3_ENDPOINT']
        }
      end
    end
  end
end
