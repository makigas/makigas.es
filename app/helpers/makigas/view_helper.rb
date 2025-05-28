# frozen_string_literal: true

module Makigas
  module ViewHelper
    COMPONENTS = {
      layout: 'Makigas::LayoutComponent',
      wrapper: 'Makigas::WrapperComponent',
      sidebar: 'Makigas::SidebarComponent'
    }.freeze

    COMPONENTS.each do |name, target|
      define_method(:"makigas_#{name}") do |*args, **kwargs, &block|
        render(target.constantize.new(*args, **kwargs), &block)
      end
    end
  end
end
