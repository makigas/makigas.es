# frozen_string_literal: true

module Five
  module Player
    # @label Discord Call To Action
    class DiscordCtaComponentPreview < ViewComponent::Preview
      # Default look and feel
      # ---------------------
      # Links to the page that would allow the user to jump to Discord.
      #
      # @display max_width 500px
      def default
        render(Five::Player::DiscordCtaComponent.new)
      end
    end
  end
end
