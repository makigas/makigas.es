# frozen_string_literal: true

module Dashboard
  module Table
    class TableHeadingComponent < ViewComponent::Base
      def initialize(label = nil, **opts)
        super()
        @label = label
        @primary = opts[:primary]
        @html_options = opts[:html_options] || {}
      end

      def classes
        return unless @primary

        'primary'
      end
    end
  end
end
