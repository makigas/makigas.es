# frozen_string_literal: true

class CreateTips < ActiveRecord::Migration[7.2]
  def change
    create_table :tips do |t|
      t.timestamps
      t.string :slug, default: nil
      t.string :title, default: nil, null: false
      t.string :description, default: nil, null: false
      t.string :status, default: 'draft', null: false
      t.text :content, default: nil, null: false
      t.string :youtube_id, default: nil, null: true
      t.references :user, default: nil, null: true
      t.references :taxonomy, default: nil, null: false
      t.string :tags, array: true, default: [], null: false
      t.datetime :published_at, default: nil, null: false
      t.integer :views_total, default: 0
      t.integer :views_recent, default: 0
    end

    add_index :tips, %i[slug taxonomy_id], unique: true
    add_index :tips, :youtube_id, unique: true
    add_index :tips, :published_at
    add_index :tips, :tags
  end
end
