# frozen_string_literal: true

module Dashboard
  module Table
    class TableRowComponent < ViewComponent::Base
      renders_one :primary, Dashboard::Table::PrimaryCellComponent

      renders_many :cells, lambda { |value = nil, class: nil, &block|
        if value.present?
          content_tag(:td, value, class:)
        else
          content_tag(:td, class:, &block)
        end
      }
    end
  end
end
