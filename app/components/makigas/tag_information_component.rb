# frozen_string_literal: true

module Makigas
  class TagInformationComponent < Makigas::Component
    def initialize(title:, body:, icon:, icon_hd: nil, **)
      super
      @title = title
      @body = body
      @icon = icon
      @icon_hd = icon_hd || icon
    end

    private

    attr_reader :title, :body

    def icon_src
      @icon
    end

    def icon_srcset
      "#{@icon}, #{@icon_hd} 2x"
    end
  end
end
