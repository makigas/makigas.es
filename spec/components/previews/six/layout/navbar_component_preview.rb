# frozen_string_literal: true

module Six
  module Layout
    # @layout Navbar
    class NavbarComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a navbar
      def default
        render Six::Layout::NavbarComponent.new
      end

      def scoped_search
        render Six::Layout::NavbarComponent.new(search_for: 'java')
      end

      def without_search
        render Six::Layout::NavbarComponent.new(show_search: false)
      end
    end
  end
end
