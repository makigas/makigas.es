# frozen_string_literal: true

class AddSearchExclussionToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :exclude_from_search, :boolean, default: false, null: false
  end
end
