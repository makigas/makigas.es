# frozen_string_literal: true

module Six
  module Search
    # Takes care of rendering a link to the playlist part of a search result.
    # This component will refuse to render itself if the playlist given is not
    # present.
    class ResultPlaylistComponent < ViewComponent::Base
      attr_reader :playlist

      # Build a new component used to present a playlist.
      # @param playlist [Playlist] the playlist to present.
      def initialize(playlist:)
        super
        @playlist = playlist
      end

      def render?
        playlist.present?
      end

      def call
        render Six::Utils::MetaComponent.new(icon: 'list', preffix: 'Serie:') do
          link_to(playlist.title, playlist_path(playlist))
        end
      end
    end
  end
end
