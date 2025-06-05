# frozen_string_literal: true

module Makigas
  class SearchResultComponent < Makigas::Component
    def initialize(title:, description:, label:, url:, icon:, icon_hd:, trend: nil, **)
      super
      @title = title
      @description = description
      @url = url
      @label = label
      @icon = icon
      @trend = trend
      @icon_hd = icon_hd
    end

    private

    attr_reader :title, :description, :url, :label, :icon, :icon_hd, :trend

    def srcset
      "#{icon}, #{icon_hd} 2x"
    end
  end
end
