# frozen_string_literal: true

module Dashboard
  module Table
    class CellMetadataComponent < ViewComponent::Base
      renders_many :keys, Dashboard::Table::CellMetadataEntryComponent
    end
  end
end
