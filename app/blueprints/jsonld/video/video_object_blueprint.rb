# frozen_string_literal: true

module Jsonld
  module Video
    class VideoObjectBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'video', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'VideoObject' }

        field(:same_as) { |video| "https://www.youtube.com/watch?v=#{video.youtube_id}" }
        field(:title, name: :name)
        field(:description)
        field(:thumbnail_url) { |video| "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg" }
        field(:upload_date) { |video| video.published_at.iso8601 }
        field(:duration) { |video| ActiveSupport::Duration.build(video.duration).iso8601 }
        field(:embed_url) { |video| "https://www.youtube.com/embed/#{video.youtube_id}" }
        field(:url) do |video, options|
          routes.playlist_video_url(video, playlist_id: video.playlist, host: options[:host])
        end
        field(:author, if: ->(_, video, _) { video.user.present? }) do |video, options|
          Jsonld::User::AuthorBlueprint.render_as_hash(video.user, **options.except(:view))
        end
        reference(:encodes_creative_work, blueprint: EpisodeBlueprint)
      end
    end
  end
end
