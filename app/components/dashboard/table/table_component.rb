# frozen_string_literal: true

module Dashboard
  module Table
    class TableComponent < ViewComponent::Base
      def initialize(expand: false)
        super
        @expand = expand
      end

      renders_one :head, Dashboard::Table::TableHeaderComponent

      renders_one :body, Dashboard::Table::TableContentComponent
    end
  end
end
