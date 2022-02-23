# frozen_string_literal: true

module Six
  module Explorer
    # @label Playlist video card
    class PlaylistVideoCardComponentPreview < ViewComponent::Preview
      # Renders a playlist
      #
      # @display padding 10px
      def default
        render Six::Explorer::PlaylistVideoCardComponent.new(video: Video.first)
      end
    end
  end
end
