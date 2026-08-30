# frozen_string_literal: true

module Six
  module Explorer
    class TopicThumbnailComponent < ViewComponent::Base
      def initialize(topic: nil, name: nil)
        super()
        @topic = topic
        @name = name
      end

      private

      attr_reader :topic

      def standard_icon
        helpers.url_for(topic.thumbnail_variant(:default))
      end

      def hidef_icon
        helpers.url_for(topic.thumbnail_variant(:hidef))
      end

      def name
        @name || topic.title
      end

      def videos
        Video.joins(playlist: :topic).where(playlists: { topic: }).count
      end

      def playlists
        topic.playlists.count
      end
    end
  end
end
