# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.timestamps
      t.string :title, null: false, length: 50
      t.string :slug, null: false
      t.string :description, null: false, length: 250
      t.attachment :icon
    end

    add_index :tags, :slug, unique: true
  end
end
