# frozen_string_literal: true

module Six
  module Search
    class TagInformationComponent < ViewComponent::Base
      include Makigas::ViewHelper

      def initialize(tag:)
        super
        @tag = tag
      end
    end
  end
end
