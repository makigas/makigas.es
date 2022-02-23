# frozen_string_literal: true

module Six
  module Explorer
    # @label Playlist card
    class PlaylistCardComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a playlist
      #
      # @display padding 10px
      def default
        render Six::Explorer::PlaylistCardComponent.new(playlist: Playlist.first)
      end
    end
  end
end
