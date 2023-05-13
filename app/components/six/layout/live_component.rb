# frozen_string_literal: true

module Six
  module Layout
    class LiveComponent < ViewComponent::Base
      def render?
        stream[:live]
      end

      def title
        stream[:title]
      end

      def thumbnail
        stream[:thumbnail]
      end

      private

      def stream
        Twitch::Live.stream_info
      end
    end
  end
end
