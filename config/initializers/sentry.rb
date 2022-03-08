# frozen_string_literal: true

if Rails.application.secrets.sentry_dsn.present?
  Sentry.init do |config|
    config.dsn = Rails.application.secrets.sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]
    config.traces_sample_rate = 0.5
  end
end
