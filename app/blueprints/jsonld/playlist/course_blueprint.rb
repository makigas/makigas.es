# frozen_string_literal: true

module Jsonld
  module Playlist
    class CourseBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |playlist, options|
        routes.playlist_url(playlist, anchor: 'course', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'Course' }
        field(:title, name: :name)
        field(:description)
        field(:url) { |playlist, options| routes.playlist_url(playlist, host: options[:host]) }
        field(:in_language) { 'es' }
        field(:is_accessible_for_free) { true }
        reference(:provider, blueprint: PublisherBlueprint)
        field(:has_part) do |playlist, options|
          playlist.videos.map do |video|
            Jsonld::Video::LessonBlueprint.render_as_hash(video, host: options[:host])
          end
        end
      end
    end
  end
end
