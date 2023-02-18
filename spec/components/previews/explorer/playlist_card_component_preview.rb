# frozen_string_literal: true

module Explorer
  # @label Playlist card
  class PlaylistCardComponentPreview < ViewComponent::Preview
    # Renders a playlist
    #
    # @display padding 10px
    def default
      render Six::Explorer::PlaylistCardComponent.new(playlist: Playlist.first)
    end
  end
end
