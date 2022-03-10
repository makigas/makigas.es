# frozen_string_literal: true

module Six
  module Explorer
    class TopicThumbnailComponent < ViewComponent::Base
      def initialize(topic: nil, name: nil)
        super
        @topic = topic
        @name = name
      end

      private

      attr_reader :topic

      def standard_icon
        topic.thumbnail.url(:default)
      end

      def hidef_icon
        topic.thumbnail.url(:hidef)
      end

      def name
        @name || topic.title
      end

      def videos
        Video.joins(playlist: :topic).where(playlists: { topic: topic }).count
      end

      def playlists
        topic.playlists.count
      end
    end
  end
end
