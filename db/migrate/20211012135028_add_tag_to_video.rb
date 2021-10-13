# frozen_string_literal: true

class AddTagToVideo < ActiveRecord::Migration[6.1]
  def change
    add_column :videos, :tags, :string, array: true, default: []
  end
end
