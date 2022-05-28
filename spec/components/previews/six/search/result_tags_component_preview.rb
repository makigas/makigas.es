# frozen_string_literal: true

module Six
  module Search
    # @label Tags
    class ResultTagsComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a tags emblem in the search results for a video.
      # @param title text
      def default(tags: 'c, java, git')
        tag_list = tags.split(',').map(&:strip)
        render(Six::Search::ResultTagsComponent.new(tags: tag_list))
      end
    end
  end
end
