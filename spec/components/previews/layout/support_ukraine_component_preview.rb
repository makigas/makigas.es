# frozen_string_literal: true

module Layout
  # @label Support Ukraine
  class SupportUkraineComponentPreview < ViewComponent::Preview
    # Renders the banner
    def default
      render Six::Layout::SupportUkraineComponent.new
    end
  end
end
