# frozen_string_literal: true

module Makigas
  module Playlist
    class EpisodeListComponent < Makigas::Component
      def initialize(playlist:, **args)
        super
        @playlist = playlist
      end

      private

      attr_reader :playlist

      delegate :videos, to: :playlist
    end
  end
end
