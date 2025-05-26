# frozen_string_literal: true

module Makigas
  module Front
    class TagExplorerComponent < Makigas::Component
      def initialize(tags:, link:, **kwargs)
        super
        @tags = tags
        @link = link
      end

      private

      attr_reader :tags, :link
    end
  end
end
