# frozen_string_literal: true

module Six
  module Layout
    class NavbarExplorerComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # @display max_width 600px
      def default
        render Six::Layout::NavbarExplorerComponent.new
      end
    end
  end
end
