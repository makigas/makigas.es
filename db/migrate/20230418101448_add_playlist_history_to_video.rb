# frozen_string_literal: true

class AddPlaylistHistoryToVideo < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :old_playlist_ids, :integer, default: [], null: false, array: true
    add_index :videos, :old_playlist_ids
  end
end
