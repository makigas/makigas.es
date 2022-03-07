# frozen_string_literal: true

module Six
  module Explorer
    class TopicCardComponent < ViewComponent::Base
      include ViewComponent::Translatable

      with_collection_parameter :topic

      def initialize(topic:)
        super
        @topic = topic
      end
    end
  end
end
