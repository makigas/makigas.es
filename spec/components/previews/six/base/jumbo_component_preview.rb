# frozen_string_literal: true

module Six
  module Base
    class JumboComponentPreview < ViewComponent::Preview
      layout 'component_preview_six'

      # @param text text the text to place
      def default(text: 'Política de privacidad')
        render(Six::Base::JumboComponent.new(text: text))
      end
    end
  end
end
