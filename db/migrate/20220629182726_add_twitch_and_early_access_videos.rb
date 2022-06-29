# frozen_string_literal: true

class AddTwitchAndEarlyAccessVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :twitch_id, :string, null: true, default: nil
    add_column :videos, :early_access, :boolean, default: false, null: false
    add_index :videos, :early_access
  end
end
