# frozen_string_literal: true

module Plausible
  class MonthAnalyzer
    def initialize(value)
      @value = value
      @this_month = @value[30..]
      @previous_month = @value[0..29]
    end

    def month_compare
      this_sum = month_forecast
      prev_sum = reduce_month(previous_month)
      %i[visits pageviews visit_duration].index_with { |k| fold_comparison(this_sum, prev_sum, k) }
    end

    def month_forecast
      reduce_month(this_month)
    end

    private

    attr_reader :value, :this_month, :previous_month

    def fold_comparison(this, previous, key)
      delta = (((this[key].to_f / previous[key]) - 1) * 100).round
      { value: this[key], previous: previous[key], delta: delta }
    end

    def reduce_month(month)
      accum = month.reduce(Hash::new(0)) do |total, day|
        duration = day["visit_duration"] * day["visits"]
        { pageviews: total[:pageviews] + day["pageviews"],
          visit_duration: total[:visit_duration] + duration,
          visits: total[:visits] + day["visits"] }
      end
      accum[:visit_duration] = (accum[:visit_duration].to_f / accum[:visits]).round
      accum
    end
  end
end
