# frozen_string_literal: true

module Explorer
  class SidebarExplorerComponent < ViewComponent::Base
    renders_many :filters, Explorer::SidebarFilterComponent
    renders_one :main
  end
end
