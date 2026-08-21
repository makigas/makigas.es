# frozen_string_literal: true

module Dashboard
  module Table
    class PrimaryCellComponent < ViewComponent::Base
      renders_one :actions

      renders_one :cell

      renders_one :metadata, Dashboard::Table::CellMetadataComponent

      def initialize(label = nil)
        super()
        @label = label
      end
    end
  end
end
