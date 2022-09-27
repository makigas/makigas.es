# frozen_string_literal: true

module Six
  module Utils
    class ForumCallToActionComponent < ViewComponent::Base
      def initialize(url:)
        super
        @url = url
      end
    end
  end
end
