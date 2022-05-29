# frozen_string_literal: true

module Six
  module Search
    class CurrentFiltersComponent < ViewComponent::Base
      def initialize(filters: {})
        super
        @filters = filters
      end

      def render?
        active_filters.present?
      end

      private

      attr_reader :filters

      MESSAGES = {
        q: 'Texto',
        length: 'Longitud',
        topic: 'Tema',
        tag: 'Etiqueta'
      }.freeze

      LENGTHS = {
        short: 'Cortos (<5 min)',
        medium: 'Medios (5 a 15 min)',
        long: 'Largos (>15 min)'
      }.freeze

      def filter_q
        params[:q]
      end

      def filter_length
        filters[:length].present? ? LENGTHS[filters[:length].to_sym] : nil
      end

      def filter_topic
        return nil if filters[:topic].blank?

        Topic.find_by(slug: filters[:topic].first)&.title
      end

      def filter_tag
        return nil if filters[:tag].blank?

        "##{filters[:tag]}"
      end

      def active_filters
        valid_filters.filter { |f| params[f].present? }
      end

      def valid_filters
        %i[q length topic tag]
      end
    end
  end
end
