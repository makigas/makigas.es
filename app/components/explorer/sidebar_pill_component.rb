# frozen_string_literal: true

module Explorer
  class SidebarPillComponent < ViewComponent::Base
    def initialize(**options)
      super
      @title = options[:active]
      @url = options[:url]
      @active = options[:active].present?
      @icon_before = options[:icon_before]
      @icon_after = options[:icon_after]
      @force_pad_left = options[:force_pad_left]
    end
  end
end
