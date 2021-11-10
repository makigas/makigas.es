# frozen_string_literal: true

class PlaylistVideoCardComponentStories < ViewComponent::Storybook::Stories
  layout 'storybook'

  story :default do
    video = Video.first
    constructor(video: video)
  end
end
