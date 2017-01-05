class AddPositionToPlaylist < ActiveRecord::Migration[5.0]
  def change
    add_column :playlists, :position, :integer
    add_index :playlists, :position
  end
end
