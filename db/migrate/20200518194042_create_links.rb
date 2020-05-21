# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.timestamps
      t.string :name, default: nil, null: false
      t.string :description, default: nil, null: false
      t.string :url, default: nil, null: false
      t.references :video, default: nil, null: false
    end
  end
end
