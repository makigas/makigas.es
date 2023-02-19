# frozen_string_literal: true

module Six
  module Layout
    class PlaylistHeaderComponent < ViewComponent::Base
      def initialize(playlist:)
        super
        @playlist = playlist
      end

      def duration
        duration = helpers.running_time total_seconds, long: true
        counter = duration.split(':').take(2).join(':')
        word = if total_seconds >= 3600
                 "horas"
               elsif total_seconds >= 60
                 "minutos"
               else
                 "segundos"
               end
        "#{counter} #{word}"
      end

      private

      def total_seconds
        @playlist.videos.visible.map(&:duration).sum
      end
    end
  end
end
