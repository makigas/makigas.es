# frozen_string_literal: true

module Layout
  class NavbarExplorerComponentPreview < ViewComponent::Preview
    # @display max_width 600px
    def default
      render Six::Layout::NavbarExplorerComponent.new
    end
  end
end
