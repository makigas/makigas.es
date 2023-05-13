# frozen_string_literal: true

module Twitch
  class Client
    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
    end

    def stream_information(login_name)
      resp = helix_client.get("/helix/streams?user_login=#{login_name}")
      raise Net::HTTPError.new("Invalid status code: #{resp.status}", resp) unless resp.status == 200

      resp.body['data'][0]
    end

    def authentication_token
      @authentication_token ||= fetch_authentication_token
    end

    private

    def fetch_authentication_token
      response = auth_client.post('/oauth2/token', login_payload)
      raise Net::HTTPError, "Invalid status code: #{resp.status}" unless response.status == 200

      response.body['access_token']
    end

    def helix_client
      logger = Logger.new $stderr
      logger.level = Logger::DEBUG
      @helix_client ||= Faraday.new(url: 'https://api.twitch.tv', headers: api_headers) do |f|
        f.request :json
        f.response :json
        f.response :logger, logger
      end
    end

    def auth_client
      logger = Logger.new $stderr
      logger.level = Logger::DEBUG
      @auth_client ||= Faraday.new(url: 'https://id.twitch.tv') do |f|
        f.request :json
        f.response :json
        f.response :logger, logger
      end
    end

    attr_reader :client_id, :client_secret

    def login_payload
      { client_id:, client_secret:, grant_type: 'client_credentials' }
    end

    def api_headers
      { 'Client-Id': client_id, Authorization: "Bearer #{authentication_token}" }
    end
  end
end
