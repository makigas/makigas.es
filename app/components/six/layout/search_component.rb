# frozen_string_literal: true

module Six
  module Layout
    class SearchComponent < ViewComponent::Base
      def initialize(query: nil, size: :normal)
        super
        @query = query
        @size = size
      end

      private

      CSS_CLASSES = {
        normal: 'searchbar--normal',
        large: 'searchbar--large'
      }.freeze

      def search_class
        CSS_CLASSES[@size]
      end
    end
  end
end
