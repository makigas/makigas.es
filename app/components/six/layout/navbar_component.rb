# frozen_string_literal: true

module Six
  module Layout
    class NavbarComponent < ViewComponent::Base
      def initialize(show_search: true, search_for: nil)
        super
        @show_search = show_search
        @search_for = search_for
      end

      private

      attr_reader :show_search, :search_for
    end
  end
end
