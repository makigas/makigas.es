# frozen_string_literal: true

module Six
  module Layout
    # @label Footer
    class FooterComponentPreview < ViewComponent::Preview
      # Renders a footer
      def default
        render Six::Layout::FooterComponent.new
      end
    end
  end
end
