# frozen_string_literal: true

module Search
  class Paginator
    def initialize(total_pages:, page:, pagination_range: 3)
      @total_pages = total_pages.to_i
      @page = page.to_i
      @pagination_range = pagination_range.to_i
    end

    attr_reader :total_pages, :page

    def first_page?
      page == 1
    end

    def last_page?
      page == total_pages
    end

    def next_page
      return nil if last_page?

      page + 1
    end

    def prev_page
      return nil if first_page?

      page - 1
    end

    def page_range
      range_start..range_end
    end

    private

    attr_reader :pagination_range

    def range_start
      initial = page - pagination_range
      initial = (total_pages - extended_pagination_range + 1) if page >= (total_pages - pagination_range)
      initial = 1 if initial < 1
      initial
    end

    def range_end
      final = page + pagination_range
      final = extended_pagination_range if page <= pagination_range
      final = total_pages if final > total_pages
      final
    end

    # How many items should be in the range (capped at total_pages)
    def extended_pagination_range
      (2 * pagination_range) + 1
    end
  end
end
