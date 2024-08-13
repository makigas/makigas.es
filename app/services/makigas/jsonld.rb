# frozen_string_literal: true

module Makigas
  class Jsonld
    class << self
      def schema_duration(duration)
        ActiveSupport::Duration.build(duration).iso8601
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def episode_schema(video)
        Jbuilder.new do |json|
          json.key_format! camelize: :lower

          json.name video.title
          json.description video.description
          json.keywords video.tags
          json.date_created video.created_at.iso8601
          json.date_modified video.updated_at.iso8601
          json.date_published video.published_at&.iso8601
          json.time_required schema_duration(video.duration)
          json.duration schema_duration(video.duration)
          json.image video.playlist.card.url(:default)
          json.thumbnail_url video.playlist.thumbnail.url(:thumb)
          json.episode_number video.position
        end.attributes!
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      def video_schema(video)
        Jbuilder.new do |json|
          json.key_format! camelize: :lower

          json.name video.title
          json.description video.description
          json.thumbnail_url "https://i1.ytimg.com/vi/#{video.youtube_id}/mqdefault.jpg"
          json.upload_date video.published_at ? video.published_at&.iso8601 : video.created_at.iso8601
          json.duration schema_duration(video.duration)
          json.embed_url "https://www.youtube.com/embed/#{video.youtube_id}"
        end.attributes!
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
