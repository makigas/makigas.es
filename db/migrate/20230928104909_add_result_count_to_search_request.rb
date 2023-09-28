# frozen_string_literal: true

class AddResultCountToSearchRequest < ActiveRecord::Migration[7.0]
  def change
    add_column :search_requests, :count, :integer, default: 0, null: false
  end
end
