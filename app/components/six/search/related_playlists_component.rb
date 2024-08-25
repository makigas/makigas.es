# frozen_string_literal: true

module Six
  module Search
    class RelatedPlaylistsComponent < ViewComponent::Base
      def initialize(tag:)
        super
        @tag = tag
      end

      def playlists
        @playlists ||= Playlist.includes(:videos).where(id: playlist_ids, exclude_from_search: false).sort_by do |p|
          (p.views_recent || 0) + (p.video_views_recent / p.videos.length)
        end.reverse
      end

      def render?
        playlists.present?
      end

      private

      def playlist_ids
        @playlist_ids = Video.filter_by_tag(@tag.slug).distinct.pluck(:playlist_id)
      end
    end
  end
end
