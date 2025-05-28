# frozen_string_literal: true

module Makigas
  module Playlist
    class BodyComponent < Makigas::Component
      def initialize(playlist:, **kwargs)
        super
        @playlist = playlist
      end

      private

      attr_reader :playlist

      def text
        playlist.excerpt.presence || playlist.description
      end
    end
  end
end
