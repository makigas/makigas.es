# frozen_string_literal: true

module Makigas
  module Playlist
    class BodyComponent < Makigas::Component
      def initialize(playlist:, **kwargs)
        super
        @playlist = playlist
      end

      private

      attr_reader :playlist

      def body
        content = playlist.excerpt.presence || playlist.description
        render = MarkdownRenderer.new
        markdown = Redcarpet::Markdown.new(render, fenced_code_blocks: true,
                                                   tables: true, quote: true,
                                                   prettify: true)
        markdown.render(content)
      end
    end
  end
end
