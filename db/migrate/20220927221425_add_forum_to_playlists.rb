# frozen_string_literal: true

class AddForumToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :forum_url, :string, null: true, default: nil
  end
end
