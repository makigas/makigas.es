# frozen_string_literal: true

module Six
  module Utils
    # @label Discord Call To Action
    class DiscordCallToActionComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # Renders a call to action to visit the Discord server
      #
      # @display max_width 500px
      def default
        render Six::Utils::DiscordCallToActionComponent.new
      end
    end
  end
end
