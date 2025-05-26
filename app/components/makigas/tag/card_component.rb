# frozen_string_literal: true

module Makigas
  module Tag
    class CardComponent < Makigas::Component
      def initialize(tag:)
        super
        @tag = tag
      end

      private

      attr_reader :tag
    end
  end
end
