# frozen_string_literal: true

module Six
  module Explorer
    class DeprecatedPlaylistComponent < ViewComponent::Base
      def initialize(playlist:)
        super
        @playlist = playlist
      end

      attr_reader :playlist
    end
  end
end
