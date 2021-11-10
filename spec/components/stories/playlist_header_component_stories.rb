# frozen_string_literal: true

class PlaylistHeaderComponentStories < ViewComponent::Storybook::Stories
  layout 'storybook'

  story :default do
    playlist = Playlist.first
    constructor(playlist: playlist)
  end
end
