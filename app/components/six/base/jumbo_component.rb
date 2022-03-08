# frozen_string_literal: true

module Six
  module Base
    class JumboComponent < ViewComponent::Base
      def initialize(text: nil)
        super
        @text = text
      end

      private

      attr_reader :text
    end
  end
end
