# frozen_string_literal: true

module Makigas
  class SearchFilterComponent < Makigas::Component
    def initialize(label:, url:, **)
      super
      @label = label
      @url = url
    end

    attr_reader :label, :url
  end
end
