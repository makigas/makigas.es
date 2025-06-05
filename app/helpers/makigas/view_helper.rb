# frozen_string_literal: true

module Makigas
  module ViewHelper
    COMPONENTS = {
      layout: 'Makigas::LayoutComponent',
      markdown: 'Makigas::MarkdownComponent',
      paginator: 'Makigas::PaginatorComponent',
      search_filter: 'Makigas::SearchFilterComponent',
      search_result: 'Makigas::SearchResultComponent',
      sidebar: 'Makigas::SidebarComponent',
      tag_information: 'Makigas::TagInformationComponent',
      trend: 'Makigas::TrendComponent',
      wrapper: 'Makigas::WrapperComponent'
    }.freeze

    COMPONENTS.each do |name, target|
      define_method(:"makigas_#{name}") do |*args, **kwargs, &block|
        render(target.constantize.new(*args, **kwargs), &block)
      end
    end
  end
end
