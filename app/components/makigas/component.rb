# frozen_string_literal: true

module Makigas
  class Component < ViewComponent::Base
    include Makigas::ViewHelper

    def initialize(css_classes: nil, **ignored_args)
      super
      @css_classes = css_classes
    end

    def extra_css_classes
      class_names(@css_classes)
    end
  end
end
