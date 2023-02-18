# frozen_string_literal: true

module Lesson
  class PartOfPlaylistComponentPreview < ViewComponent::Preview
    def default
      video = Playlist.first.videos.reverse[3]
      render(Six::Lesson::PartOfPlaylistComponent.new(video:))
    end
  end
end
