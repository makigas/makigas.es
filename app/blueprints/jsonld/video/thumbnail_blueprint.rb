# frozen_string_literal: true

module Jsonld
  module Video
    class ThumbnailBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'thumbnail', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'ImageObject' }

        field(:url) { |video| "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg" }
      end
    end
  end
end
