# frozen_string_literal: true

class AddDeprecatedToPlaylist < ActiveRecord::Migration[7.2]
  def change
    add_column :playlists, :deprecated, :boolean, null: false, default: false
    add_reference :playlists, :replacement_playlist, null: true
  end
end
