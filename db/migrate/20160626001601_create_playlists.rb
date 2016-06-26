class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|

      # This is the title of the playlist.
      t.string :title, null: false, length: 100

      # This is the contents of the playlist.
      t.text :description, null: false, length: 1500

      # This is the ID for the associated YouTube playlist.
      t.string :youtube_id, null: false, length: 100

      # This is the associated slug to this model.
      t.string :slug, null: false

      t.timestamps null: false
    end

    # Slugs are part of the URL most of the time so make them fast.
    add_index :playlists, :slug, unique: true
  end
end
