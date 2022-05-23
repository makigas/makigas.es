# frozen_string_literal: true

module Five
  module Core
    # @label Media card
    class MediaCardComponentPreview < ViewComponent::Preview
      # Renders a card
      #
      # @param href text
      # @param thumb text
      # @param title text
      # @param text textarea
      def default(href: '#', thumb: '/android-chrome-192x192.png', title: 'A sample card', text: 'Lorem Ipsum')
        render Five::Core::MediaCardComponent.new(href:,
                                                  thumbnail: thumb,
                                                  hidef_thumbnail: thumb) do |c|
          c.title { title }
          c.text { text }
        end
      end
    end
  end
end
