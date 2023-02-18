# frozen_string_literal: true

module Search
  # @label Topic
  class ResultTopicComponentPreview < ViewComponent::Preview
    # Renders a topic emblem in the search results for a video.
    # @param title text
    def default(title: 'A topic')
      topic = Topic.new(title:, slug: title.parameterize)
      render(Six::Search::ResultTopicComponent.new(topic:))
    end
  end
end
