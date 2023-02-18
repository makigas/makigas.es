# frozen_string_literal: true

module Six
  module Lesson
    class PartOfPlaylistComponent < ViewComponent::Base
      def initialize(video:)
        super
        @video = video
      end

      private

      attr_reader :video

      def playlist
        video.playlist
      end

      def other_videos
        playlist.videos.visible.order(position: :asc)
      end
    end
  end
end
