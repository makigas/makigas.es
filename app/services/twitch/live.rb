# frozen_string_literal: true

module Twitch
  class Live
    def self.stream_info
      instance = Twitch::Live.new
      { live: instance.currently_live, title: instance.stream_title, thumbnail: instance.stream_thumbnail }
    end

    def currently_live
      stream_information.present?
    end

    def stream_title
      return nil unless stream_information.present?

      stream_information['title']
    end

    def stream_thumbnail
      return nil unless stream_information.present?

      stream_information['thumbnail_url'].gsub('{width}', '640').gsub('{height}', '360')
    end

    private

    def stream_information
      Rails.cache.fetch('twitch:stream_information', expires_in: 10.minutes) do
        puts('Fetching stream information!')
        return [] if channel_name.blank?

        client = Twitch::Client.new(Rails.application.secrets.twitch_client_id,
                                    Rails.application.secrets.twitch_secret_key)
        client.stream_information(channel_name)
      end
    end

    def client_id
      Rails.application.secrets.twitch_client_id
    end

    def secret_key
      Rails.application.secrets.twitch_secret_key
    end

    def channel_name
      Rails.application.secrets.twitch_user_login
    end
  end
end
