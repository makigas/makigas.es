# frozen_string_literal: true

module Six
  module Layout
    # @label Playlist header
    class PlaylistHeaderComponentPreview < ViewComponent::Preview
      # Renders a playlist
      #
      # @display bgcolor '#2196f3'
      def default
        render Six::Layout::PlaylistHeaderComponent.new(playlist: Playlist.first)
      end
    end
  end
end
