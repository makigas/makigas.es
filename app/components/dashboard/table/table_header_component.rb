# frozen_string_literal: true

module Dashboard
  module Table
    class TableHeaderComponent < ViewComponent::Base
      renders_many :headings, Dashboard::Table::TableHeadingComponent
    end
  end
end
