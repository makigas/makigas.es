# frozen_string_literal: true

class DeleteUnfeaturedAndPrivateFieldsFromVideo < ActiveRecord::Migration[7.0]
  def change
    remove_column :videos, :unfeatured, :boolean, null: false, default: false
    remove_column :videos, :private, :boolean, null: false, default: false
  end
end
