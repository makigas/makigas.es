# frozen_string_literal: true

module Dashboard
  class SortableHeaderComponent < ViewComponent::Base
    attr_reader :key, :params, :label, :keep

    def initialize(key:, label:, params:, keep: {})
      super
      @key = key
      @label = label
      @params = params
      @keep = keep.index_with { |k| params[k] }
    end

    private

    def criteria
      params[:sort].present? ? params[:sort].gsub(/^[+-]/, '') : nil
    end

    def sorting?
      criteria == key.to_s
    end

    def order
      if params[:sort].present? && params[:sort].starts_with?('-')
        :desc
      else
        :asc
      end
    end

    def opposite_order
      return :asc unless sorting?

      order == :desc ? :asc : :desc
    end

    def opposite_param
      opposite_order == :asc ? '' : '-'
    end
  end
end
