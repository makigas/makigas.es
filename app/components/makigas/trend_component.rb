# frozen_string_literal: true

module Makigas
  class TrendComponent < Makigas::Component
    TRENDS = {
      rising: '📈 En tendencia',
      popular: '🔥 Popular'
    }.freeze

    def initialize(trend:)
      super
      @trend = trend
    end

    def render?
      trend.present? && TRENDS.include?(trend.to_sym)
    end

    def call
      tag.span(class: 'Trend') { TRENDS[trend.to_sym] }
    end

    private

    attr_reader :trend
  end
end
