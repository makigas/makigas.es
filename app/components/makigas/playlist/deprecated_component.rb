# frozen_string_literal: true

module Makigas
  module Playlist
    class DeprecatedComponent < Makigas::Component
      def initialize(playlist:)
        super
        @playlist = playlist
      end

      attr_reader :playlist
    end
  end
end
