# frozen_string_literal: true

module Six
  module Explorer
    class VideoListItemComponent < ViewComponent::Base
      def initialize(video: nil)
        super
        @video = video
      end

      private

      attr_reader :video
    end
  end
end
