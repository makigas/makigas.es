# frozen_string_literal: true

module Dashboard
  module Table
    class CellMetadataEntryComponent < ViewComponent::Base
      def initialize(label, value = nil)
        super
        @label = label
        @value = value
      end
    end
  end
end
