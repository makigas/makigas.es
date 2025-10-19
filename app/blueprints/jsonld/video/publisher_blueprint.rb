# frozen_string_literal: true

module Jsonld
  module Video
    class PublisherBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'publisher', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Organization' }
        field(:name) { 'Makigas' }
        field(:url) { 'https://www.makigas.es' }
      end
    end
  end
end
