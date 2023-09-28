# frozen_string_literal: true

class CreateSearchRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :search_requests do |t|
      t.timestamps
      t.string :query, null: true, index: true
      t.integer :page, default: 1
      t.jsonb :filters, null: false, default: '{}'
      t.string :error, null: true
    end

    add_index :search_requests, :filters, using: :gin
  end
end
