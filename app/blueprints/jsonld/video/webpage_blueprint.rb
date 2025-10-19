# frozen_string_literal: true

module Jsonld
  module Video
    class WebpageBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'webpage', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'WebPage' }

        field(:name) { |video| "#{video.title} – #{video.playlist.title}" }
        field(:description)

        reference(:publisher, blueprint: Jsonld::PublisherBlueprint)
      end
    end
  end
end
