# frozen_string_literal: true

module Five
  module Catalog
    class PlaylistMediaCardComponent < Five::Base
      attr_reader :playlist

      def initialize(playlist:)
        super
        @playlist = playlist
      end

      def call
        render Five::Core::MediaCardComponent.new(
          href:,
          thumbnail:,
          hidef_thumbnail:
        ) do |c|
          c.with_title { title }
          c.with_text { description }
        end
      end

      private

      delegate :title, to: :playlist

      def description
        t('.explore_other_videos', count: playlist.videos.count)
      end

      def href
        helpers.playlist_path(playlist)
      end

      def thumbnail
        playlist.thumbnail.url(:small)
      end

      def hidef_thumbnail
        playlist.thumbnail.url(:default)
      end
    end
  end
end
