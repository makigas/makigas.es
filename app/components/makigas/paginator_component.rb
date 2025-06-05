# frozen_string_literal: true

module Makigas
  class PaginatorComponent < Makigas::Component
    SIDE_PAGES = 3

    def initialize(page:, total_pages:, link:, **)
      super
      @page = page
      @total_pages = total_pages
      @link = link
    end

    private

    attr_reader :page, :total_pages, :link

    def paginator
      @paginator ||= Search::Paginator.new(total_pages:, page:, pagination_range: SIDE_PAGES)
    end

    delegate :first_page?, :last_page?, :page_range, to: :paginator

    def link_to_page(page, **, &)
      helpers.link_to(link.call(page), **, &)
    end
  end
end
