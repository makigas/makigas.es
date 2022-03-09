# frozen_string_literal: true

module Six
  module Explorer
    class PlaylistListComponent < ViewComponent::Base
      def initialize(playlists: [])
        super
        @playlists = playlists
      end

      private

      attr_reader :playlists
    end
  end
end
