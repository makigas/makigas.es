# frozen_string_literal: true

module Six
  module Explorer
    class ChildTopicsComponent < ViewComponent::Base
      include Makigas::ViewHelper
      include ViewComponent::Translatable

      with_collection_parameter :topic

      def render?
        @topic.child_topics.present?
      end

      def initialize(topic:)
        super()
        @topic = topic
      end
    end
  end
end
