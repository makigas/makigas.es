# frozen_string_literal: true

module Six
  module Search
    # Takes care of rendering a link to the topic part of a search result.
    # This component will refuse to render itself if the topic given is not
    # present.
    class ResultTopicComponent < ViewComponent::Base
      attr_reader :topic

      # Build a new component used to present a topic.
      # @param topic [Topic] the topic to present.
      def initialize(topic:)
        super
        @topic = topic
      end

      def render?
        topic.present?
      end

      def call
        render Six::Utils::MetaComponent.new(icon: 'book-open', preffix: 'Tema:') do
          link_to(topic.title, topic_path(topic))
        end
      end
    end
  end
end
