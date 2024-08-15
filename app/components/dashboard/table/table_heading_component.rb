# frozen_string_literal: true

module Dashboard
  module Table
    class TableHeadingComponent < ViewComponent::Base
      def initialize(label = nil, **opts)
        super
        @label = label
        @primary = opts[:primary]
        @html_options = opts[:html_options] || {}
      end

      def classes
        if @primary
          'primary'
        else
          nil
        end
      end
    end
  end
end
