# frozen_string_literal: true

class AddExcerptToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :excerpt, :text, null: true
  end
end
