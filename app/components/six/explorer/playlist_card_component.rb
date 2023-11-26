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
        duration = ActiveSupport::Duration.build(total_seconds)

        minutes = duration.in_minutes.to_i % 60
        hours = duration.in_hours.to_i

        [
          hours.positive? ? t('.hours', count: hours) : nil,
          minutes.positive? ? t('.minutes', count: minutes) : nil
        ].compact.join(', ')
      end

      private

      def total_seconds
        @playlist.videos.visible.map(&:duration).sum
      end
    end
  end
end
