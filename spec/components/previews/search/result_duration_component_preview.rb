# frozen_string_literal: true

module Search
  # @label Duration
  class ResultDurationComponentPreview < ViewComponent::Preview
    # Renders a duration in the search results for a video.
    # @param seconds
    def default(seconds: 1234)
      render(Six::Search::ResultDurationComponent.new(seconds: seconds.to_i))
    end
  end
end
