# frozen_string_literal: true

module Plausible
  class Integration
    def self.client
      Plausible::Integration.new.client
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
