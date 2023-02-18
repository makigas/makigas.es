# frozen_string_literal: true

module Search
  # @label Tags
  class ResultTagsComponentPreview < ViewComponent::Preview
    # Renders a tags emblem in the search results for a video.
    # @param tags text
    def default(tags: 'c, java, git')
      tag_list = tags.split(',').map(&:strip)
      render(Six::Search::ResultTagsComponent.new(tags: tag_list))
    end
  end
end
