# frozen_string_literal: true

module Explorer
  class SidebarFilterComponent < ViewComponent::Base
    def initialize(title: nil)
      super
      @title = title
    end

    renders_one :title
    renders_many :pills, Explorer::SidebarPillComponent
  end
end
