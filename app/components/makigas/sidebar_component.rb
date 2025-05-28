# frozen_string_literal: true

module Makigas
  class SidebarComponent < Makigas::Component
    renders_many :sections, Makigas::Sidebar::BoxComponent

    private

    def class_list
      ['SidebarList', extra_css_classes]
    end
  end
end
