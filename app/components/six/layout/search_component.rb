# frozen_string_literal: true

module Six
  module Layout
    class SearchComponent < ViewComponent::Base
      include RailsFeather::Helper

      renders_many :hidden_fields, lambda { |key:, value:|
        tag.input(type: 'hidden', name: key, value:)
      }

      def initialize(query: nil, size: :normal, variant: :dark)
        super()
        @query = query
        @size = size
        @variant = variant
      end

      CSS_CLASSES = {
        normal: 'searchbar--normal',
        large: 'searchbar--large',
        dark: 'searchbar--dark',
        light: 'searchbar--light'
      }.freeze
      private_constant :CSS_CLASSES

      private

      def search_class
        [CSS_CLASSES[@size], CSS_CLASSES[@variant]].join(' ')
      end
    end
  end
end
