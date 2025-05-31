# frozen_string_literal: true

module Types
  class SymbolType < ActiveModel::Type::Value
    def cast(value)
      return value.to_sym if value.present?

      nil
    end

    def type
      :symbol
    end
  end
end
