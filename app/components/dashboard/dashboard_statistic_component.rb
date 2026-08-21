# frozen_string_literal: true

module Dashboard
  class DashboardStatisticComponent < ViewComponent::Base
    def initialize(label:, value:, increment:)
      super()
      @label = label
      @value = value
      @increment = increment
    end

    private

    attr_reader :label, :value, :increment

    def pill_class
      if increment.positive?
        'text-bg-success'
      elsif increment.negative?
        'text-bg-warning'
      else
        'text-bg-secondary'
      end
    end
  end
end
