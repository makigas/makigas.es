# frozen_string_literal: true

module Six
  module Utils
    class TrendComponent < ViewComponent::Base
      def initialize(video:)
        super
        @video = video
      end

      def render?
        badge.present?
      end

      def badge
        @video.trend_tag
      end
    end
  end
end
