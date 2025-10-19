# frozen_string_literal: true

module Jsonld
  module Video
    class EpisodeBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'episode', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Episode' }

        field(:title, name: :name)
        field(:description)
        field(:tags, name: :keywords)
        field(:date_created) { |video| video.created_at.iso8601 }
        field(:date_modified) { |video| video.updated_at.iso8601 }
        field(:date_published) { |video| video.published_at.iso8601 }
        field(:thumbnail_url) { |video| "https://i1.ytimg.com/vi/#{video.youtube_id}/maxresdefault.jpg" }
        field(:time_required) { |video| ActiveSupport::Duration.build(video.duration).iso8601 }
        field(:position, name: :episode_number)
        reference(:author, blueprint: AuthorBlueprint, if: ->(video) { video.user.present? })
        reference(:publisher, blueprint: PublisherBlueprint)
        reference(:part_of_series, blueprint: SeriesBlueprint)
      end
    end
  end
end
