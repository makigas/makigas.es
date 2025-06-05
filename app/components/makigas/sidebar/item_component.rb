# frozen_string_literal: true

module Makigas
  module Sidebar
    class ItemComponent < Makigas::Component
      def initialize(value: nil, active: false, href: nil, icon_before: nil, icon_after: nil, role: nil, **kwargs)
        super
        @value = value
        @active = active
        @href = href
        @role = role
        @icon_before = icon_before || default_icon_before
        @icon_after = icon_after
      end

      private

      attr_reader :value, :href, :icon_before, :icon_after, :active, :role

      def class_list
        ['SidebarItem', { 'SidebarItem--active': active }, extra_css_classes]
      end

      def default_icon_before
        case role
        when :radio
          active ? 'disc' : 'circle'
        when :check
          active ? 'check-square' : 'square'
        end
      end

      def root_element(&)
        if href.present?
          link_to(href, class: class_list, &)
        else
          tag.span(class: class_list, &)
        end
      end

      def icon(name)
        feather_icon(name, class: 'SidebarItem__icon')
      rescue StandardError
        nil
      end
    end
  end
end
