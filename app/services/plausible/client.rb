# frozen_string_literal: true

module Plausible
  class Client
    def initialize(site_id, api_key)
      @site_id = site_id
      @api_key = api_key
    end

    def breakdown(date)
      request_breakdown(date, 1)
    end

    def time_series
      resp = client.get('timeseries', timeseries_params)
      raise Net::HTTPError.new("Invalid status code: #{resp.status}", resp) unless resp.status == 200

      resp.body['results']
    end

    private

    attr_reader :site_id, :api_key

    def request_breakdown(date, page = 1)
      resp = client.get('breakdown', breakdown_params(date, page))
      raise Net::HTTPError.new("Invalid status code: #{resp.status}", resp) unless resp.status == 200

      results = resp.body['results']
      return results if results.empty?

      # Make recursive request until we find an empty page
      next_page = request_breakdown(date, page + 1)
      results + next_page
    end

    def client
      @client ||= Faraday.new(url: 'https://plausible.io/api/v1/stats/', headers:) do |f|
        f.request :json
        f.response :json
      end
    end

    def timeseries_params
      yesterday = DateTime.current.yesterday
      sixty_days_ago = yesterday - 59.days # one less because otherwise it is one more

      date = "#{sixty_days_ago.strftime('%F')},#{yesterday.strftime('%F')}"
      { site_id:, period: 'custom', date:, metrics: 'visits,pageviews,visit_duration' }
    end

    def breakdown_params(date, page = 1)
      date = date.strftime('%F') if date.is_a?(DateTime)

      { site_id:, period: 'day', date:,
        property: 'event:page', metrics: 'pageviews',
        limit: 250, page: }
    end

    def headers
      { Authorization: "Bearer #{api_key}",
        'Content-Type': 'application/json' }
    end
  end
end
