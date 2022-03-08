# frozen_string_literal: true

module Five
  module Core
    class MediaCardComponent < Five::Base
      renders_one :title
      renders_one :text

      attr_reader :thumbnail, :href

      def initialize(href:, thumbnail:, hidef_thumbnail:)
        super
        @href = href
        @thumbnail = thumbnail
        @hidef_thumbnail = hidef_thumbnail
      end

      def srcset
        "#{@thumbnail}, #{@hidef_thumbnail} 2x"
      end
    end
  end
end
