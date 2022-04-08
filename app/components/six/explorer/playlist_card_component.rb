# frozen_string_literal: true

module Six
  module Explorer
    class PlaylistCardComponent < ViewComponent::Base
      include ViewComponent::Translatable

      with_collection_parameter :playlist

      def initialize(playlist:)
        super
        @playlist = playlist
      end

      def duration
        parts = ActiveSupport::Duration.build(total_seconds).parts
        minutes = t('.minutes', count: parts[:minutes])
        return minutes if parts[:hours].blank?

        hours = t('.hours', count: parts[:hours])
        [hours, minutes].join(', ')
      end

      private

      def total_seconds
        @playlist.videos.visible.map(&:duration).sum
      end
    end
  end
end
