# frozen_string_literal: true

module Six
  module Layout
    class NavbarExplorerComponent < ViewComponent::Base
      def topics
        Topic.all
      end
    end
  end
end
