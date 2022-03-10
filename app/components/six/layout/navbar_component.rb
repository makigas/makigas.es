# frozen_string_literal: true

module Six
  module Layout
    class NavbarComponent < ViewComponent::Base
      def initialize(show_search: true, search_for: nil, classes: nil)
        super
        @show_search = show_search
        @search_for = search_for
        @classes = classes
      end

      private

      attr_reader :show_search, :search_for

      def class_list
        classes = ['navbar']
        classes << @classes if @classes.present?
        classes.flatten.join(' ')
      end
    end
  end
end
