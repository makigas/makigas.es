# frozen_string_literal: true

class PlaylistCardComponentStories < ViewComponent::Storybook::Stories
  layout 'storybook'

  story :default do
    playlist = Playlist.last
    constructor(playlist: playlist)
  end
end
