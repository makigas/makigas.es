class AddThumbnailToPlaylist < ActiveRecord::Migration[5.0]
  def up
    add_attachment :playlists, :thumbnail
  end
  
  def down
    remove_attachment :playlists, :thumbnail
  end
end
