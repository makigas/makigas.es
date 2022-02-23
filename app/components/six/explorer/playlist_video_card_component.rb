# frozen_string_literal: true

module Six
  module Explorer
    class PlaylistVideoCardComponent < ViewComponent::Base
      include ViewComponent::Translatable

      with_collection_parameter :video

      def initialize(video:)
        super
        @video = video
      end

      def duration
        helpers.running_time(@video.duration)
      end

      def published_at
        helpers.l @video.published_at.to_date, format: :long
      end
    end
  end
end
