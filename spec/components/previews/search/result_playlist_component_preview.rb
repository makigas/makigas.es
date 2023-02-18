# frozen_string_literal: true

module Search
  # @label Playlist
  class ResultPlaylistComponentPreview < ViewComponent::Preview
    # Renders a playlist emblem in the search results for a video.
    # @param title text
    def default(title: 'A playlist')
      playlist = Playlist.new(title:, slug: title.parameterize)
      render(Six::Search::ResultPlaylistComponent.new(playlist:))
    end
  end
end
