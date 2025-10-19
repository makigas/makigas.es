# frozen_string_literal: true

module Jsonld
  module Video
    class ArticleBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'article', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'TechArticle' }
        field(:title, name: :headline)
        field(:date_modified) { |video| video.updated_at.iso8601 }
        field(:date_published) { |video| video.published_at.iso8601 }
        reference(:author, blueprint: AuthorBlueprint, if: ->(video) { video.user.present? })
        reference(:publisher, blueprint: PublisherBlueprint)
        reference(:image, blueprint: ThumbnailBlueprint)
        reference(:associated_media, blueprint: VideoObjectBlueprint)
      end
    end
  end
end
