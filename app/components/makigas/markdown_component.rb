# frozen_string_literal: true

require 'rouge/plugins/redcarpet'

module Makigas
  class MarkdownComponent < Makigas::Component
    def initialize(text:, **kwargs)
      super
      @text = text
    end

    def call
      markdown = Redcarpet::Markdown.new(Renderer, fenced_code_blocks: true,
                                                   tables: true, quote: true,
                                                   prettify: true)
      helpers.sanitize(markdown.render(text))
    end

    private

    class Renderer < Redcarpet::Render::HTML
      include Rouge::Plugins::Redcarpet
    end

    attr_reader :text
  end
end
