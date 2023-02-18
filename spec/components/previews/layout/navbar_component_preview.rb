# frozen_string_literal: true

module Layout
  class NavbarComponentPreview < ViewComponent::Preview
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
