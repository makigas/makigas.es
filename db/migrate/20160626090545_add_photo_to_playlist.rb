# frozen_string_literal: true

class AddPhotoToPlaylist < ActiveRecord::Migration[4.2]
  def up
    # This is the thumbnail that is displayed in the playlists page.
    add_attachment :playlists, :photo
  end

  def down
    remove_attachment :playlists, :photo
  end
end
