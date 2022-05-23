# frozen_string_literal: true

module Six
  module Layout
    # @label Search bar
    class SearchComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders the search
      #
      # @param query text
      # @param size select [normal, large]
      # @display bgcolor '#222'
      # @display padding 50px
      def default(query: '', size: :normal)
        render Six::Layout::SearchComponent.new(query: query.presence, size:)
      end
    end
  end
end
