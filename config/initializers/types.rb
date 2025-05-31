# frozen_string_literal: true

require Rails.root.join('lib/types/symbol_type.rb')

ActiveModel::Type.register(:symbol, Types::SymbolType)
