# frozen_string_literal: true

module Jsonld
  module Video
    class LessonBlueprint < Jsonld::JsonldBlueprint
      transform Jsonld::CamelTransformer

      identifier(:@id) do |video, options|
        routes.playlist_video_url(video, playlist_id: video.playlist, anchor: 'lesson', host: options[:host])
      end

      view(:full) do
        field(:@type) { 'CreativeWork' }
        field(:learning_resource_type) { 'Lesson' }

        field(:url) do |video, options|
          routes.playlist_video_url(video, playlist_id: video.playlist, host: options[:host])
        end

        field(:title, name: :name)
        field(:description)
        field(:position)
        field(:time_required) { |video| ActiveSupport::Duration.build(video.duration).iso8601 }
        association(:playlist, name: :is_part_of, blueprint: Jsonld::Playlist::CourseBlueprint)
      end
    end
  end
end
