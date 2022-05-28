# frozen_string_literal: true

module Six
  module Search
    # @label Duration
    class ResultDurationComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a duration in the search results for a video.
      # @param seconds
      def default(seconds: 1234)
        render(Six::Search::ResultDurationComponent.new(seconds: seconds.to_i))
      end
    end
  end
end
