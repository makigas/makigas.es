# frozen_string_literal: true

class CreateOpinions < ActiveRecord::Migration[5.0]
  def change
    create_table :opinions do |t|
      t.timestamps
      t.string :from, null: false, default: nil
      t.string :message, null: false, default: nil
      t.string :url, null: true
      t.attachment :photo, null: false, default: nil
    end
  end
end
