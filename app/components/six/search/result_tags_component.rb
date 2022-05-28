# frozen_string_literal: true

module Six
  module Search
    # Takes care of rendering a list of tags in the search result. This
    # component will refuse to render itself if it is not given a valid
    # list of tags to present.
    class ResultTagsComponent < ViewComponent::Base
      attr_reader :tags

      # Build a new component used to present a list of tags.
      # @param tags [Array[String]] the list of tags to present.
      def initialize(tags: [])
        super
        @tags = tags
      end

      def render?
        tags.present? # assumes that present? returns true for length > 0
      end

      def call
        render Six::Utils::MetaComponent.new(icon: 'hash', preffix: 'Etiquetas:') do
          tag_links = tags.map { |tag| link_to(tag, videos_path(tag:)) }
          safe_join(tag_links, ', ')
        end
      end
    end
  end
end
