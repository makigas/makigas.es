# frozen_string_literal: true

module Search
  # @label Empty
  class EmptyComponentPreview < ViewComponent::Preview
    # Renders the error message when no search results were found
    def default
      render Six::Search::EmptyComponent.new
    end
  end
end
