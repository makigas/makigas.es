# frozen_string_literal: true

module Six
  module Base
    class YoutubeEmbedComponent < ViewComponent::Base
      def initialize(youtube_id:)
        super
        @youtube_id = youtube_id
      end

      private

      attr_reader :youtube_id
    end
  end
end
