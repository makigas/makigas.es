# frozen_string_literal: true

module Six
  module Layout
    class FooterComponent < ViewComponent::Base
      def popular_playlists
        popular_playlists_by_index
      end

      # The playlists whose playlist page has the more views.
      def popular_playlists_by_index
        Playlist.where(exclude_from_search: false, deprecated: false)
                .order(normalized_views_recent: :desc).take(6)
      end

      # The playlists whose content is the most popular.
      def popular_playlists_by_video
        Video
          .group('playlist_id')
          .select('sum(views_recent) as total, playlist_id')
          .order(total: :desc)
      end
    end
  end
end
