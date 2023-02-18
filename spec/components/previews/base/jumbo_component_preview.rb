# frozen_string_literal: true

module Base
  class JumboComponentPreview < ViewComponent::Preview
    # @param text text the text to place
    def default(text: 'Política de privacidad')
      render(Six::Base::JumboComponent.new(text:))
    end
  end
end
