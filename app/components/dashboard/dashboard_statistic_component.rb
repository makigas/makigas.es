# frozen_string_literal: true

module Dashboard
  class DashboardStatisticComponent < ViewComponent::Base
    def initialize(label:, value:, increment:)
      @label = label
      @value = value
      @increment = increment
    end

    private

    attr_reader :label, :value, :increment

    def pill_class
      if increment > 0
        'text-bg-success'
      elsif increment < 0
        'text-bg-warning'
      else
        'text-bg-secondary'
      end
    end
  end
end
