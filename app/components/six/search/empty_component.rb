# frozen_string_literal: true

module Six
  module Search
    class EmptyComponent < ViewComponent::Base
      def initialize(filters: {})
        super
        @filters = filters
      end

      private

      attr_reader :filters

      def emojis
        %w[😔 😖 😣 ☹️ 😢 😓]
      end

      def search_url
        "https://www.youtube.com/@makigas/search?query=#{search_query}"
      end

      def search_query
        [filters[:q], filters[:tag]].flatten.compact.join(' ')
      end
    end
  end
end
