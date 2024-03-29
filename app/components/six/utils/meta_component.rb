# frozen_string_literal: true

module Six
  module Utils
    # The meta is a piece of HTML text that gets presented in some parts such
    # as the playlist card. It renders an icon and some text. This is mostly
    # a wrapper to avoid having to repeat a lot of boilerplate code on
    # every component that renders the same thing.
    #
    # This component yields to the HTML text that should be presented as part
    # of the meta. Other parameters should be given as parameters when
    # the component is created.
    class MetaComponent < ViewComponent::Base
      attr_reader :preffix

      # @param icon [String] the icon to present in the component.
      # @param text [String] the text to provide to the component.
      # @param preffix [String] if given, a text to put before the text
      def initialize(icon:, text: nil, preffix: nil)
        super
        @icon = icon
        @text = text
        @preffix = preffix
      end

      def inner_content
        @text || content
      end
    end
  end
end
