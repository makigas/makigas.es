# frozen_string_literal: true

module Makigas
  module Playlist
    class HeaderComponent < Makigas::Component
      def initialize(playlist:, **kwargs)
        super
        @playlist = playlist
      end

      private

      attr_reader :playlist

      def playlist_icon
        helpers.url_for(playlist.thumbnail)
      end

      def playlist_iconset
        hidef = helpers.url_for(playlist.thumbnail_variant(:hidef))
        normal = playlist_icon
        "#{normal}, #{hidef} 2x"
      end

      def duration
        duration = helpers.running_time total_seconds, long: true
        counter = duration.split(':').take(2).join(':')
        word = if total_seconds >= 3600
                 'horas'
               elsif total_seconds >= 60
                 'minutos'
               else
                 'segundos'
               end
        "#{counter} #{word}"
      end

      def total_seconds
        playlist.videos.visible.map(&:duration).sum
      end

      def transcribed?
        videos = Video.where(playlist:).pluck(:id)
        transcriptions = Transcription.where(documentable_type: 'Video', documentable_id: videos)
        videos.length == transcriptions.length
      end
    end
  end
end
