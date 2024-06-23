# frozen_string_literal: true

class AddExcerptToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :excerpt, :text, null: true
  end
end
