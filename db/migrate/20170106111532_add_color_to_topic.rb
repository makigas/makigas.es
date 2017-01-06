class AddColorToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :color, :string
  end
end
