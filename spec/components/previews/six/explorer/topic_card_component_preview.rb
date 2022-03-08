# frozen_string_literal: true

module Six
  module Explorer
    # @label Topic card
    class TopicCardComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a topic
      #
      # @display padding 10px
      def default
        render Six::Explorer::TopicCardComponent.new(topic: Topic.first)
      end
    end
  end
end
