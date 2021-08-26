# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :title, null: false, length: 50
      t.string :description, null: false, length: 250
      t.attachment :photo
      t.string :slug, null: false
      t.timestamps
    end
    add_column :playlists, :topic_id, :integer
    add_index :playlists, :topic_id
    add_index :topics, :slug, unique: true
  end
end
