# frozen_string_literal: true

module Makigas
  class LayoutComponent < Makigas::Component
    renders_one :sidebar, 'Makigas::SidebarComponent'

    def initialize(position: nil, responsive_toggle_button_text: 'Toggle', **kwargs)
      super
      @position = validate_position(position)
      @responsive_toggle_button_text = responsive_toggle_button_text
    end

    private

    attr_reader :position, :responsive_toggle_button_text

    def class_list
      ['Layout', { 'Layout--right': position == :right }, extra_css_classes]
    end

    def validate_position(pos)
      return pos if pos.nil?

      return pos.to_sym if %i[left right].include?(pos.to_sym)

      raise "Unexpected position argument: #{pos}"
    end
  end
end
