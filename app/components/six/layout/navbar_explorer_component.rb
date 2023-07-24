# frozen_string_literal: true

module Six
  module Layout
    class NavbarExplorerComponent < ViewComponent::Base
      def topics
        Topic.where(parent_topic_id: nil)
      end
    end
  end
end
