# frozen_string_literal: true

module Five
  module Catalog
    class TopicMediaCardComponent < Five::Base
      attr_reader :topic

      def initialize(topic:)
        super
        @topic = topic
      end

      def call
        render Five::Core::MediaCardComponent.new(
          href:,
          thumbnail:,
          hidef_thumbnail:
        ) do |c|
          c.with_title { title }
          c.with_text { description }
        end
      end

      private

      delegate :title, :description, to: :topic

      def href
        helpers.topic_path(topic)
      end

      def thumbnail
        topic.thumbnail.url(:small)
      end

      def hidef_thumbnail
        topic.thumbnail.url(:default)
      end
    end
  end
end
