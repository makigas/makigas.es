# frozen_string_literal: true

module Dashboard
  module Table
    class TableContentComponent < ViewComponent::Base
      renders_many :rows, Dashboard::Table::TableRowComponent
    end
  end
end
