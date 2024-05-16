class AddTopicPositionToPlaylist < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :topic_position, :integer, default: 0, null: false
  end
end
