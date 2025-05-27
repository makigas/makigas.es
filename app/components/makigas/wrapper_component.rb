# frozen_string_literal: true

module Makigas
  class WrapperComponent < Makigas::Component
    def initialize(tag: :div, fluid: false, breath: false, slim: false, **kwargs)
      super
      @tag = tag
      @fluid = fluid
      @breath = breath
      @slim = slim
    end

    def call
      content_tag(tag, class: class_list) do
        content
      end
    end

    private

    attr_reader :tag, :fluid, :breath, :slim

    def class_list
      ['wrapper', { 'wrapper--fluid': fluid, 'wrapper--breath': breath, 'wrapper--slim': slim }, extra_css_classes]
    end
  end
end
