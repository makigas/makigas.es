# frozen_string_literal: true

class AddViewCountersToPlaylist < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :views_total, :integer, default: 0
    add_column :playlists, :views_recent, :integer, default: 0
  end
end
