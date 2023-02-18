# frozen_string_literal: true

module Layout
  # @label Footer
  class FooterComponentPreview < ViewComponent::Preview
    # Renders a footer
    def default
      render Six::Layout::FooterComponent.new
    end
  end
end
