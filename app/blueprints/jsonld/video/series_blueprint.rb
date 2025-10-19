# frozen_string_literal: true

module Jsonld
  module Video
    class SeriesBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'series', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'CreativeWorkSeries' }
        field(:name) { |video| video.playlist.title }
        field(:description) { |video| video.playlist.description }
        field(:abstract) { |video| video.playlist.description }
        field(:date_created) { |video| video.playlist.created_at.iso8601 }
        field(:date_modified) { |video| video.playlist.content_updated_at.iso8601 }
        field(:date_published) { |video| video.playlist.videos.first.published_at.iso8601 }
        field(:keywords) { |video| video.playlist.videos.pluck(:tags).flatten.uniq.sort }
        field(:thumbnail_url) { |video| video.playlist.thumbnail.url(:thumb) }
        field(:image) { |video| video.playlist.card.url(:thumb) }
        reference(:publisher, blueprint: PublisherBlueprint)
        reference(:author, blueprint: AuthorBlueprint, if: ->(video) { video.user.present? })
        field(:url) { |video, options| routes.playlist_url(video.playlist, host: options[:host]) }
        field(:same_as) { |video| "https://www.youtube.com/playlist?list=#{video.playlist.youtube_id}" }
      end
    end
  end
end
