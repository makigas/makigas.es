class AddSortToSearchQuery < ActiveRecord::Migration[7.0]
  def change
    add_column :search_requests, :sort, :string, default: nil, null: true
  end
end
