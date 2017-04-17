class AddPrivateToVideos < ActiveRecord::Migration[5.0]
  def change
    add_column :videos, :private, :boolean, default: false, null: false
  end
end
