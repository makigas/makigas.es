# frozen_string_literal: true

class AddNormalizedViewsToPlaylists < ActiveRecord::Migration[7.2]
  def change
    add_column :playlists, :normalized_views_total, :bigint, default: 0, null: false
    add_column :playlists, :normalized_views_recent, :bigint, default: 0, null: false
  end
end
