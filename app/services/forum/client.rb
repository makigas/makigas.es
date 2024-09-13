# frozen_string_literal: true

module Forum
  class Client
    def request(req)
      return do_request(req) if req.cache_key.nil?

      Rails.cache.fetch("forum/#{req.cache_key}", expires_in: 10.minutes) do
        do_request(req)
      end
    end

    private

    def do_request(req)
      resp = req.request(client)
      req.process(resp.body)
    end

    def client
      @client ||= Faraday.new('https://foro.makigas.es/api/', headers:) do |f|
        f.request :json
        f.response :json
      end
    end

    def headers
      { 'Content-Type': 'application/json',
        'User-Agent': 'makigas/6.0 (+https://www.makigas.es)' }
    end
  end
end
