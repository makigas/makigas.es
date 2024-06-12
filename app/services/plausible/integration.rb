# frozen_string_literal: true

module Plausible
  class Integration
    def self.client
      Plausible::Integration.new.client
    end

    def self.last_30_days(compare: false)
      data = Rails.cache.fetch('plausible:last_30_days', expires_in: 2.hours) do
        client.time_series
      end
      if compare
        Plausible::MonthAnalyzer.new(data).month_compare
      else
        Plausible::MonthAnalyzer.new(data).month_forecast
      end
    end

    def client
      Plausible::Client.new(site_id, api_key)
    end

    private

    def site_id
      Rails.application.secrets.plausible_domain
    end

    def api_key
      Rails.application.secrets.plausible_api_key
    end
  end
end
