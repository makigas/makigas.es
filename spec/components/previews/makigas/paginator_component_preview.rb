# frozen_string_literal: true

module Makigas
  class PaginatorComponentPreview < ViewComponent::Preview
    # @param total_pages number
    # @param page number
    def playground(page: 10, total_pages: 20)
      render Makigas::PaginatorComponent.new(
        page:,
        total_pages:,
        link: ->(n) { "?page=#{n}&total_pages=#{total_pages}" }
      )
    end
  end
end
