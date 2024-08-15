# frozen_string_literal: true

module Six
  module Layout
    class PlaylistHeaderComponent < ViewComponent::Base
      def initialize(playlist:)
        super
        @playlist = playlist
      end

      def body
        content = @playlist.excerpt.presence || @playlist.description
        render = MarkdownRenderer.new
        markdown = Redcarpet::Markdown.new(render, fenced_code_blocks: true,
                                                   tables: true, quote: true,
                                                   prettify: true)
        markdown.render(content)
      end

      def duration
        duration = helpers.running_time total_seconds, long: true
        counter = duration.split(':').take(2).join(':')
        word = if total_seconds >= 3600
                 'horas'
               elsif total_seconds >= 60
                 'minutos'
               else
                 'segundos'
               end
        "#{counter} #{word}"
      end

      private

      def total_seconds
        @playlist.videos.visible.map(&:duration).sum
      end
    end
  end
end
