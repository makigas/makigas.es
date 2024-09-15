# frozen_string_literal: true

class AddAggregatedViewsToPlaylist < ActiveRecord::Migration[7.2]
  def change
    add_column :playlists, :aggregated_views_total, :bigint, default: 0, null: false
    add_column :playlists, :aggregated_views_recent, :bigint, default: 0, null: false
    add_column :playlists, :aggregated_trend_tag, :string, null: true
  end
end
