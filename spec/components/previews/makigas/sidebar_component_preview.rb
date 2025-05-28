# frozen_string_literal: true

module Makigas
  class SidebarComponentPreview < ViewComponent::Preview
    def sidebar
      render Makigas::SidebarComponent.new do |sidebar|
        sidebar.with_section(header: 'Sort results') do |section|
          section.with_item(value: 'By date', href: '#sort=date')
          section.with_item(value: 'By popularity', href: '#sort=popularity')
          section.with_item(value: 'By length', href: '#sort=length')
        end
        sidebar.with_section(header: 'Limit results') do |section|
          section.with_item(value: 'Free', href: '#type=free')
          section.with_item(value: 'Premium', href: '#type=premium')
        end
      end
    end

    # @param value text
    # @param id text
    # @param href text
    # @param icon_before text
    # @param icon_after text
    # @param active toggle
    # @display padding 1rem
    def sidebar_item(id: '', active: false, value: 'Most recent', href: '', icon_before: nil, icon_after: nil)
      render Makigas::Sidebar::ItemComponent.new(value:, href:, icon_before:, icon_after:, active:, id:)
    end

    # @param header text
    # @display padding 1rem
    def sidebar_group(header: 'Sort results')
      render Makigas::Sidebar::BoxComponent.new(header:) do |group|
        group.with_item(value: 'By date', href: '#sort=date')
        group.with_item(value: 'By popularity', href: '#sort=popularity')
        group.with_item(value: 'By length', href: '#sort=length')
      end
    end
  end
end
