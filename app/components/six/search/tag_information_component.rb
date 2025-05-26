# frozen_string_literal: true

module Six
  module Search
    class TagInformationComponent < ViewComponent::Base
      def initialize(tag:)
        super
        @tag = tag
      end

      private

      def body
        render = MarkdownRenderer.new
        markdown = Redcarpet::Markdown.new(render, fenced_code_blocks: true,
                                                   tables: true, quote: true,
                                                   prettify: true)
        markdown.render(@tag.description)
      end
    end
  end
end
