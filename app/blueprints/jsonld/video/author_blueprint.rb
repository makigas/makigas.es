# frozen_string_literal: true

module Jsonld
  module Video
    class AuthorBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'author', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Person' }
        field(:name) { |video| video.user.name }
        field(:url) { |video| video.user.external_url }
      end
    end
  end
end
