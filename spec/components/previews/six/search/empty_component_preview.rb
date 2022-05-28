# frozen_string_literal: true

module Six
  module Search
    # @label Empty
    class EmptyComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders the error message when no search results were found
      def default
        render Six::Search::EmptyComponent.new
      end
    end
  end
end
