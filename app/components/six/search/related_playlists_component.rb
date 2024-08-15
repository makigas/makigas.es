# frozen_string_literal: true

module Six
  module Search
    class RelatedPlaylistsComponent < ViewComponent::Base
      def initialize(tag:)
        super
        @tag = tag
      end

      def playlists
        @playlists ||= Playlist.includes(:videos).where(id: playlist_ids, exclude_from_search: false).sort_by { |p| p.views_recent + (p.video_views_recent / p.videos.length) }.reverse
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
