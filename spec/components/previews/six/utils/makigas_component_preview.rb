# frozen_string_literal: true

module Six
  module Utils
    # @label makigas
    class MakigasComponentPreview < ViewComponent::Preview
      # Renders the logo
      #
      # @display max_width 300px
      def default
        render Six::Utils::MakigasComponent.new
      end
    end
  end
end
