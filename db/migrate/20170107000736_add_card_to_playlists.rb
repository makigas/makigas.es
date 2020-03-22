# frozen_string_literal: true

class AddCardToPlaylists < ActiveRecord::Migration[5.0]
  def up
    add_attachment :playlists, :card
  end

  def down
    remove_attachment :playlists, :card
  end
end
