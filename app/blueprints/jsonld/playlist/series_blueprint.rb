# frozen_string_literal: true

module Jsonld
  module Playlist
    class SeriesBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |playlist, options|
        routes.playlist_url(playlist, anchor: 'series', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'CreativeWorkSeries' }
        field(:title, name: :name)
        field(:description)
        field(:description, name: :abstract)
        field(:date_created) { |playlist| playlist.created_at.iso8601 }
        field(:date_modified) { |playlist| playlist.content_updated_at.iso8601 }
        field(:date_published) { |playlist| playlist.videos.first&.published_at&.iso8601 }
        field(:keywords) { |playlist| playlist.videos.pluck(:tags).flatten.uniq.sort }
        field(:thumbnail_url) { |playlist| playlist.thumbnail.url(:thumb) }
        field(:image) { |playlist| playlist.card.url(:thumb) }
        reference(:publisher, blueprint: PublisherBlueprint)
        field(:url) { |playlist, options| routes.playlist_url(playlist, host: options[:host]) }
        field(:same_as) { |playlist| "https://www.youtube.com/playlist?list=#{playlist.youtube_id}" }
      end
    end
  end
end
