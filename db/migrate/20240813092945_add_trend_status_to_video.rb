class AddTrendStatusToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :trend_tag, :string, default: nil, null: true
  end
end
